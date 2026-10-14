cmake_minimum_required(VERSION 3.24)
project(nvtx-cmake-test LANGUAGES C CXX)

find_package(nvtx3 REQUIRED CONFIG)
find_package(CUDAToolkit REQUIRED)

# A tool printing the names of the ranges pushed by the application.
add_library(injection SHARED injection.c)
target_link_libraries(injection PRIVATE nvtx3::nvtx3-c)

# The C API exported by libnvtx3interop, as provided by FindCUDAToolkit.
add_executable(interop interop.c)
target_link_libraries(interop PRIVATE CUDA::nvtx3_interop)

# The header-only C++ API, as provided by the NVTX package configuration and by FindCUDAToolkit.
add_executable(package-config range.cpp)
target_link_libraries(package-config PRIVATE nvtx3::nvtx3-cpp)
add_executable(cuda-toolkit range.cpp)
target_link_libraries(cuda-toolkit PRIVATE CUDA::nvtx3)

install(TARGETS injection interop package-config cuda-toolkit)
