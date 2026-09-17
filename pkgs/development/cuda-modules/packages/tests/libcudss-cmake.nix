{
  backendCC,
  buildPackages,
  cuda_nvcc,
  cudaNamePrefix,
  lib,
  libcudss,
  stdenvNoCC,
}:
let
  nvcc = cuda_nvcc.__spliced.buildHost or cuda_nvcc;
  cc = backendCC.__spliced.buildHost or backendCC;
in
stdenvNoCC.mkDerivation {
  name = "${cudaNamePrefix}-tests-libcudss-cmake";
  strictDeps = true;
  # Exercise the installed export without stdenv's propagated CUDA flags or
  # CUDA language initialization supplying missing usage requirements.
  buildCommand = ''
    mkdir -p "$out"
    cat > CMakeLists.txt <<'CMAKE'
    cmake_minimum_required(VERSION 3.25)
    project(cudss_consumer LANGUAGES CXX)
    find_package(cudss REQUIRED CONFIG COMPONENTS cudss_static)
    foreach(library IN ITEMS cudss cudss_static)
      add_executable(''${library}_consumer main.cpp)
      target_link_libraries(''${library}_consumer PRIVATE ''${library})
      add_executable(''${library}_solve solve.cpp)
      # The application itself allocates CUDA buffers; its runtime dependency
      # is distinct from the solver's exported link requirements above.
      target_link_libraries(''${library}_solve PRIVATE ''${library} CUDA::cudart_static)
    endforeach()
    CMAKE
    cat > main.cpp <<'CPP'
    #include <cudss.h>
    int main(int argc, char **) {
      // Retain a real solver reference to test the static runtime closure,
      // but only query the version when run without GPU hardware.
      if (argc > 1) {
        cudssHandle_t handle;
        return cudssCreate(&handle);
      }
      int version = -1;
      return cudssGetProperty(MAJOR_VERSION, &version) != CUDSS_STATUS_SUCCESS
        || version != CUDSS_VERSION_MAJOR;
    }
    CPP
    cp ${./libcudss-solve.cpp} solve.cpp
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
      -Dcudss_DIR=${lib.getDev libcudss}/lib/cmake/cudss \
      ${lib.optionalString (
        stdenvNoCC.buildPlatform != stdenvNoCC.hostPlatform
      ) "-DCMAKE_SYSTEM_NAME=Linux -DCMAKE_SYSTEM_PROCESSOR=${stdenvNoCC.hostPlatform.parsed.cpu.name}"}
    clean ${buildPackages.cmake}/bin/cmake --build build --verbose
    cp build/{cudss,cudss_static}_consumer "$out/"
    # These require GPU hardware and are run explicitly outside the sandbox.
    cp build/{cudss,cudss_static}_solve "$out/"
    cp build/CMakeCache.txt "$out/"
    ${lib.optionalString (stdenvNoCC.buildPlatform.canExecute stdenvNoCC.hostPlatform) ''
      clean "$out/cudss_consumer"
      clean "$out/cudss_static_consumer"
    ''}
  '';
}
