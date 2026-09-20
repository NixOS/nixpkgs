{
  backendStdenv,
  cmake,
  cudaConfig,
  cuda_cudart,
  cuda_nvcc,
  cuda_nvrtc,
  cuda_nvtx,
  cudaNamePrefix,
  cudaMajorMinorVersion,
  lib,
  libcublas,
  libnvjitlink,
  ninja,
  pkgs,
}:
let
  # CUDA 12 supports at most GCC 14. Using GCC 15 for ordinary C++ makes
  # accidentally replacing the project's compiler with NVCC's backend visible.
  projectStdenv = pkgs.gcc15Stdenv;
  backend = "${backendStdenv.cc}/bin/${backendStdenv.cc.targetPrefix}c++";
  compiler = lib.getExe (cuda_nvcc.__spliced.buildHost or cuda_nvcc);
  runtime = "${lib.getLib cuda_cudart}/lib/libcudart.so";
  buildCuda =
    if lib.versions.major cudaMajorMinorVersion == "12" then
      pkgs.cudaPackages_13
    else
      pkgs.cudaPackages_12_9;
in
projectStdenv.mkDerivation {
  name = "${cudaNamePrefix}-tests-nvcc-backend";
  strictDeps = true;
  dontUnpack = true;
  # A private BUILD backend must not activate BUILD flags for the project's
  # HOST compiler, even when their standard wrapper salts are identical.
  depsBuildBuild = [ buildCuda.cuda_nvcc ];
  nativeBuildInputs = [
    cmake
    ninja
    cuda_nvcc
  ];
  buildInputs = [
    cuda_cudart
    libcublas
    cuda_nvrtc
    cuda_nvtx
    libnvjitlink
  ];

  preConfigure = ''
    test "$(type -P "$CXX")" = '${projectStdenv.cc}/bin/${projectStdenv.cc.targetPrefix}g++'

    # Exercise PyTorch's actual combination of legacy FindCUDA and modern
    # CUDA language support, with the same toolkit-discovery fixes as torch.
    cp -r ${pkgs.python3Packages.torch.src}/cmake torch-cmake
    chmod -R u+w torch-cmake
    patch -d torch-cmake -p2 < ${../../../python-modules/torch/source/find-cuda-use-package-paths.patch}

    # A toolchain may override program lookup and the target prefix. Exercise
    # these cross choices even when the surrounding fixture builds natively.
    mkdir findcuda-override
    cat > findcuda-override/CMakeLists.txt <<'CMAKE'
    cmake_minimum_required(VERSION 3.18)
    set(CMAKE_SYSTEM_NAME Linux)
    project(FindCudaOverride LANGUAGES NONE)
    set(CMAKE_MODULE_PATH "''${CMAKE_CURRENT_LIST_DIR}/../torch-cmake/Modules_CUDA_fix/upstream")
    set(CUDA_USE_STATIC_CUDA_RUNTIME OFF)
    set(CMAKE_FIND_ROOT_PATH "''${CMAKE_CURRENT_BINARY_DIR}/empty-sysroot")
    set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM ONLY)
    macro(find_host_program)
      find_program(''${ARGN} NO_CMAKE_FIND_ROOT_PATH)
    endmacro()
    set(CUDA_TOOLKIT_TARGET_DIR "${lib.getLib cuda_cudart}")
    find_package(CUDA REQUIRED)
    if(NOT CUDA_TOOLKIT_TARGET_DIR STREQUAL "${lib.getLib cuda_cudart}" OR
       NOT CUDA_TOOLKIT_INCLUDE STREQUAL "${lib.getInclude cuda_cudart}/include" OR
       NOT CUDA_CUDART_LIBRARY STREQUAL "${runtime}" OR
       NOT CUDA_NVCC_EXECUTABLE STREQUAL "${compiler}")
      message(FATAL_ERROR "FindCUDA ignored the cross toolchain's selections")
    endif()
    CMAKE
    cmake -S findcuda-override -B findcuda-override-build -GNinja

    rm torch-cmake/Modules/FindCUDAToolkit.cmake
    substituteInPlace torch-cmake/public/cuda.cmake \
      --replace-fail 'set(CUDAToolkit_ROOT "' '# set(CUDAToolkit_ROOT "'
    cat > CMakeLists.txt <<'CMAKE'
    cmake_minimum_required(VERSION 3.18)
    project(NvccBackend LANGUAGES C CXX)
    include(torch-cmake/public/utils.cmake)
    set(TORCH_CUDA_ARCH_LIST "${lib.concatStringsSep ";" cudaConfig.cudaCapabilities}")
    include(torch-cmake/public/cuda.cmake)
    if(NOT CUDAToolkit_VERSION VERSION_EQUAL "${cuda_nvcc.version}")
      message(FATAL_ERROR "Incorrect toolkit version: ''${CUDAToolkit_VERSION}")
    endif()
    # FindCUDAToolkit only defines this target when version discovery works.
    if(NOT TARGET CUDA::nvJitLink)
      message(FATAL_ERROR "CUDA::nvJitLink was not discovered")
    endif()
    if(NOT CUDA_NVCC_EXECUTABLE STREQUAL "${compiler}" OR
       NOT CMAKE_CUDA_COMPILER STREQUAL "${compiler}")
      message(FATAL_ERROR "Legacy and modern CUDA must use the BUILD compiler")
    endif()
    get_target_property(cudart CUDA::cudart IMPORTED_LOCATION)
    if(NOT CUDA_CUDART_LIBRARY STREQUAL "${runtime}" OR
       NOT cudart STREQUAL "${runtime}")
      message(FATAL_ERROR "Legacy and modern CUDA must use the HOST runtime")
    endif()
    if(NOT CUDA_HOST_COMPILER STREQUAL "${backend}" OR
       NOT CMAKE_CUDA_HOST_COMPILER STREQUAL "${backend}")
      message(FATAL_ERROR "Legacy and modern CUDA must use NVCC's selected backend")
    endif()
    cuda_add_library(legacy STATIC kernel.cu)
    # Legacy FindCUDA and CMake's CUDA language must each compile a source.
    add_library(modern SHARED modern.cu project.cpp)
    target_link_libraries(modern PRIVATE CUDA::cudart CUDA::nvJitLink)
    target_link_options(modern PRIVATE "LINKER:--no-undefined")
    install(TARGETS legacy modern DESTINATION lib)
    CMAKE
    cat > kernel.cu <<'CUDA'
    #include <cuda_runtime.h>
    #include <vector>
    __global__ void kernel(float* x) { x[threadIdx.x] *= 2.0f; }
    extern "C" int launch(float* x) { kernel<<<1,32>>>(x); return cudaGetLastError(); }
    CUDA
    cp kernel.cu modern.cu
    cat > project.cpp <<'CXX'
    #if __GNUC__ != 15
    #error NVCC's backend replaced the project's C++ compiler
    #endif
    #include <cuda_runtime_api.h>
    #if CUDART_VERSION / 1000 != ${lib.versions.major cudaMajorMinorVersion}
    #error NVCC's BUILD dependencies leaked into the project's HOST compiler
    #endif
    #include <vector>
    int project_cpp() { return std::vector<int>{1, 2, 3}.size(); }
    extern "C" int launch(float*);
    extern "C" int project_launch(float* x) { return launch(x); }
    CXX
  '';
  postInstall = ''cp CMakeCache.txt "$out/CMakeCache.txt"'';
}
