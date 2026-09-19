{
  buildPackages,
  cuda_nvcc,
  cutlass,
  lib,
  stdenv,
}:
let
  nvcc = cuda_nvcc.__spliced.buildHost or cuda_nvcc;
in
stdenv.mkDerivation {
  name = "${cutlass.name}-cmake-consumer";
  strictDeps = true;
  buildInputs = [ cutlass ];
  buildCommand = ''
    mkdir -p "$out/bin"
    cat > main.cpp <<'CPP'
    #include <cutlass/numeric_types.h>
    static_assert(cutlass::sizeof_bits<cutlass::half_t>::value == 16);
    int main() {
      cutlass::half_t value(1.5f);
      return float(value) != 1.5f;
    }
    CPP

    # Ordinary header use must receive CUDA dependencies from CUTLASS itself.
    "$CXX" -std=c++17 main.cpp -o "$out/bin/headers"

    cat > CMakeLists.txt <<'CMAKE'
    cmake_minimum_required(VERSION 3.25)
    project(cutlass_consumer LANGUAGES CXX)
    find_package(NvidiaCutlass CONFIG REQUIRED)
    add_executable(consumer main.cpp)
    target_compile_features(consumer PRIVATE cxx_std_17)
    target_link_libraries(consumer PRIVATE nvidia::cutlass::cutlass)
    CMAKE

    # Also check the installed CMake interface without ambient Nix include flags
    # or activation of the NVCC setup hook. The consumer selects its toolkit.
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
      -DCMAKE_CXX_COMPILER=${stdenv.cc}/bin/${stdenv.cc.targetPrefix}c++ \
      -DCMAKE_LIBRARY_PATH=${lib.getLib stdenv.cc.libc}/lib \
      -DCMAKE_PREFIX_PATH=${cutlass} \
      -DCUDAToolkit_ROOT=${lib.getOutput nvcc.outputBin nvcc} \
      ${lib.optionalString (
        stdenv.buildPlatform != stdenv.hostPlatform
      ) "-DCMAKE_SYSTEM_NAME=Linux -DCMAKE_SYSTEM_PROCESSOR=${stdenv.hostPlatform.parsed.cpu.name}"}
    clean ${buildPackages.cmake}/bin/cmake --build build --verbose
    cp build/consumer "$out/bin/cmake"
    cp build/CMakeCache.txt "$out/"
    ${lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      clean "$out/bin/headers"
      clean "$out/bin/cmake"
    ''}
  '';
}
