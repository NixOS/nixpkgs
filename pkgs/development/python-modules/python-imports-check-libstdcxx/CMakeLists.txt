cmake_minimum_required(VERSION 3.14)

project(PythonImportsCheckLibstdcxx LANGUAGES CXX)

find_package(Python REQUIRED COMPONENTS Development Interpreter)
find_package(pybind11 CONFIG REQUIRED)

option(LOAD_LIBSTDCXX_INSTALL_SITE_PACKAGES "Path to the install location"
       ${Python_SITEARCH})

   # CMake seems to ignore the default value specified by option(), somehow:
set(LOAD_LIBSTDCXX_MODULE_NAME "load_libstdcxx" CACHE BOOL "Name of the python module")
option(LOAD_LIBSTDCXX_MODULE_NAME "Name of the python module" "load_libstdcxx")

python_add_library(load_libstdcxx MODULE WITH_SOABI main.cc)
target_link_libraries(load_libstdcxx PRIVATE pybind11::headers)
target_compile_features(load_libstdcxx PRIVATE cxx_std_20)
target_compile_definitions(
  load_libstdcxx
  PRIVATE -DLOAD_LIBSTDCXX_MODULE_NAME=${LOAD_LIBSTDCXX_MODULE_NAME})
set_target_properties(load_libstdcxx PROPERTIES OUTPUT_NAME
                                                ${LOAD_LIBSTDCXX_MODULE_NAME})

install(
  TARGETS load_libstdcxx
  COMPONENT python
  DESTINATION ${LOAD_LIBSTDCXX_INSTALL_SITE_PACKAGES}/)
