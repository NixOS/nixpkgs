{
  backendCC,
  buildPackages,
  cccl,
  cuda_cudart,
  cuda_nvcc,
  cudaNamePrefix,
  lib,
  stdenvNoCC,
}:
let
  nvcc = cuda_nvcc.__spliced.buildHost or cuda_nvcc;
  cc = backendCC.__spliced.buildHost or backendCC;
in
stdenvNoCC.mkDerivation {
  name = "${cudaNamePrefix}-tests-nvcc-cmake";
  strictDeps = true;
  # Neither the NVCC setup hook nor dependency flags may supply paths which
  # a consumer outside stdenv must discover from the installed compiler.
  # Supply only the ordinary HOST libc search directory as a cross toolchain
  # would. CUDA include and library paths must still come from NVCC.
  buildCommand = ''
    mkdir -p "$out"
    cat > CMakeLists.txt <<'CMAKE'
    cmake_minimum_required(VERSION 3.25)
    project(cuda_consumer LANGUAGES CXX)
    find_package(CUDAToolkit REQUIRED)
    foreach(required IN ITEMS
      "${lib.getOutput cuda_cudart.outputInclude cuda_cudart}/include"
      "${lib.getOutput cccl.outputInclude cccl}/include")
      if(NOT required IN_LIST CUDAToolkit_INCLUDE_DIRS)
        message(FATAL_ERROR "Missing target header directory: ''${required}")
      endif()
    endforeach()
    add_executable(consumer main.cpp)
    target_link_libraries(consumer PRIVATE CUDA::cudart)
    CMAKE
    cat > main.cpp <<'CPP'
    #include <cuda_runtime.h>
    #include <cuda/std/type_traits>
    static_assert(cuda::std::is_integral<int>::value);
    int main() {
      int version = 0;
      return cudaRuntimeGetVersion(&version) != cudaSuccess || version == 0;
    }
    CPP
    clean() {
      env -i HOME="$TMPDIR" TMPDIR="$TMPDIR" \
        PATH=${
          lib.makeBinPath [
            buildPackages.coreutils
            buildPackages.bash
            buildPackages.ninja
          ]
        } \
        "$@"
    }
    clean ${buildPackages.cmake}/bin/cmake -S . -B build -G Ninja \
      -DCMAKE_CXX_COMPILER=${cc}/bin/${cc.targetPrefix}c++ \
      -DCMAKE_LIBRARY_PATH=${lib.getLib cc.libc}/lib \
      -DCUDAToolkit_ROOT=${nvcc} \
      ${lib.optionalString (
        stdenvNoCC.buildPlatform != stdenvNoCC.hostPlatform
      ) "-DCMAKE_SYSTEM_NAME=Linux -DCMAKE_SYSTEM_PROCESSOR=${stdenvNoCC.hostPlatform.parsed.cpu.name}"}
    clean ${buildPackages.cmake}/bin/cmake --build build --verbose
    cp build/consumer "$out/consumer"
    cp build/CMakeCache.txt "$out/"
    ${lib.optionalString (stdenvNoCC.buildPlatform.canExecute stdenvNoCC.hostPlatform) ''clean "$out/consumer"''}
  '';
}
