cmake_minimum_required(VERSION 3.23)

project(cudnn_frontend VERSION 1.8.0)

option(CUDNN_FRONTEND_SKIP_JSON_LIB "Defines whether FE should not include nlohmann/json.hpp." OFF)
option(CUDNN_FRONTEND_BUILD_SAMPLES "Defines if samples are built or not." ON)
option(CUDNN_FRONTEND_BUILD_TESTS "Defines if unittests are built or not." ON)
option(CUDNN_FRONTEND_BUILD_PYTHON_BINDINGS "Defines if python bindings are built or not." OFF)

if(MSVC OR MSYS OR MINGW)
    add_compile_options(/W4 /WX)
else()
    add_compile_options(-Wall -Wextra -Wpedantic -Werror -Wno-error=attributes -Wno-attributes -Wno-error=unused-function -Wno-unused-function)
endif()

add_library(cudnn_frontend INTERFACE)

# Add header files to library
file(GLOB_RECURSE CUDNN_FRONTEND_INCLUDE_FILES "include/*")
target_sources(
    cudnn_frontend
    PUBLIC
        FILE_SET
            HEADERS
            BASE_DIRS
                "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>"
            FILES
                "${CUDNN_FRONTEND_INCLUDE_FILES}"
)
unset(CUDNN_FRONTEND_INCLUDE_FILES)

target_compile_definitions(cudnn_frontend INTERFACE $<$<BOOL:${CUDNN_FRONTEND_SKIP_JSON_LIB}>:CUDNN_FRONTEND_SKIP_JSON_LIB>)

target_include_directories(
    cudnn_frontend
    INTERFACE
        "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>"
        "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>"
)

# Find the cuda compiler
find_package(CUDAToolkit REQUIRED)

target_include_directories(cudnn_frontend INTERFACE ${CUDAToolkit_INCLUDE_DIRS})

target_compile_features(cudnn_frontend INTERFACE cxx_std_17)

# Make PCH for targets to link against
add_library(_cudnn_frontend_pch INTERFACE)
target_precompile_headers(_cudnn_frontend_pch INTERFACE ${PROJECT_SOURCE_DIR}/include/cudnn_frontend.h)

if (CUDNN_FRONTEND_BUILD_SAMPLES)
    add_subdirectory(samples)
    target_link_libraries(
        samples
        PRIVATE
            CUDA::cublasLt
            CUDA::nvrtc
    )
    target_link_libraries(
        legacy_samples
        PRIVATE
            CUDA::cublasLt
            CUDA::nvrtc
    )
endif()

if (CUDNN_FRONTEND_BUILD_TESTS)
    add_subdirectory(test)
    target_link_libraries(
        tests
        CUDA::cublasLt
        CUDA::nvrtc
    )
endif()

if (CUDNN_FRONTEND_BUILD_PYTHON_BINDINGS)
    add_subdirectory(python)
endif()

# Introduce variables:
# * CMAKE_INSTALL_LIBDIR
# * CMAKE_INSTALL_BINDIR
# * CMAKE_INSTALL_INCLUDEDIR
include(GNUInstallDirs)

# Install and export the header files
install(
    TARGETS
        cudnn_frontend
    EXPORT
        cudnn_frontend_targets
    FILE_SET HEADERS
)

if (CUDNN_FRONTEND_BUILD_SAMPLES)
    install(TARGETS legacy_samples samples RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
endif()

if (CUDNN_FRONTEND_BUILD_TESTS)
    install(TARGETS tests RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
endif()

# See https://cmake.org/cmake/help/latest/module/CMakePackageConfigHelpers.html#example-generating-package-files
include(CMakePackageConfigHelpers)

export(
    EXPORT
        cudnn_frontend_targets
    FILE
        "${CMAKE_CURRENT_BINARY_DIR}/cudnn_frontend/cudnn_frontend-targets.cmake"
)
install(
    EXPORT
        cudnn_frontend_targets
    FILE
        cudnn_frontend-targets.cmake
    DESTINATION
        "${CMAKE_INSTALL_LIBDIR}/cmake/cudnn_frontend"
)

configure_package_config_file(
    cudnn_frontend-config.cmake.in
    "${CMAKE_CURRENT_BINARY_DIR}/cudnn_frontend-config.cmake"
    INSTALL_DESTINATION
        "${CMAKE_INSTALL_LIBDIR}/cmake/cudnn_frontend"
)
install(
    FILES
        "${CMAKE_CURRENT_BINARY_DIR}/cudnn_frontend-config.cmake"
    DESTINATION
        "${CMAKE_INSTALL_LIBDIR}/cmake/cudnn_frontend"
)
