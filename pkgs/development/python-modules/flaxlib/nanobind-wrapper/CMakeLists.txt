cmake_minimum_required(VERSION 3.31)
project(nanobind-wrapper)

find_package(Python COMPONENTS Interpreter Development REQUIRED)
find_package(nanobind CONFIG REQUIRED)
nanobind_build_library(nanobind-static)
set_property(TARGET nanobind-static PROPERTY EXPORT_NAME nanobind)
install(TARGETS nanobind-static EXPORT nanobind-static)
install(EXPORT nanobind-static FILE nanobindConfig.cmake DESTINATION lib/nanobind/cmake)
