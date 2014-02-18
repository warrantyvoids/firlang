all: firc

LLVM_ROOT = ../bin

SOURCES = main.cpp parser.cpp tokens.cpp

OBJS = $(SOURCES:.cpp=.o)

LLVM_CONFIG = $(LLVM_ROOT)/llvm-config
CC          = $(LLVM_ROOT)/clang
CPP         = $(LLVM_ROOT)/clang++
CPPFLAGS = `$(LLVM_CONFIG) --libs core native --cxxflags` -O2 --std=c++11
LDFLAGS = `$(LLVM_CONFIG) --libs core native --ldflags`
LIBS = `$(LLVM_CONFIG) --libs`


parser.h: parser.cpp
parser.cpp: parser.y
	bison --defines=parser.h -o parser.cpp parser.y
	
tokens.cpp: tokens.l
	lex -o tokens.cpp tokens.l
	
%.o: %.cpp
	$(CPP) -c $(CPPFLAGS) -o $@ $<
	
firc: $(OBJS)
	$(CPP) $(LDFLAGS) $(LIBS) $(OBJS) -o $@
