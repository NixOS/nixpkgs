cmake_minimum_required(VERSION 2.6)

project(ilbc)

file(GLOB ilbc_SRCS *.c)
file(GLOB ilbc_HDRS *.h)

add_library(ilbc SHARED ${ilbc_SRCS})

install(TARGETS ilbc DESTINATION lib)
install(FILES ${ilbc_HDRS} DESTINATION include/ilbc)
