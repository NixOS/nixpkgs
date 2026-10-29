cmake_minimum_required(VERSION 3.14)
set(PROJECT_NAME "sqlite3_flutter_libs")
project(${PROJECT_NAME} LANGUAGES C CXX)

# This value is used when generating builds using this plugin, so it must
# not be changed
set(PLUGIN_NAME "sqlite3_flutter_libs_plugin")

find_package(PkgConfig REQUIRED)
pkg_check_modules(SQLITE REQUIRED sqlite3)

add_library(${PLUGIN_NAME} SHARED
  "sqlite3_flutter_libs_plugin.cc"
)

target_compile_features(${PLUGIN_NAME} PUBLIC cxx_std_14)
target_compile_options(${PLUGIN_NAME} PRIVATE "$<$<NOT:$<CONFIG:Debug>>:-O3>")

set_target_properties(${PLUGIN_NAME} PROPERTIES
  CXX_VISIBILITY_PRESET hidden)
target_compile_definitions(${PLUGIN_NAME} PRIVATE FLUTTER_PLUGIN_IMPL)
target_include_directories(${PLUGIN_NAME} INTERFACE
  "${CMAKE_CURRENT_SOURCE_DIR}/include")
target_link_libraries(${PLUGIN_NAME} PRIVATE flutter)
