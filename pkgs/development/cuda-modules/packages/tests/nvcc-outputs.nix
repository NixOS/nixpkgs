{
  buildPackages,
  cudaConfig,
  cudaNamePrefix,
  cuda_cudart,
  cuda_nvcc,
  lib,
  stdenvNoCC,
  zlib,
}:
let
  buildNvcc = cuda_nvcc.__spliced.buildHost or cuda_nvcc;
  # Relocate the complete compiler/NVVM prefix without changing its internal
  # layout. The out output remains buildRedist's normal aggregation output.
  nvcc = buildNvcc.overrideAttrs (previous: {
    outputs = [
      "out"
      "bin"
    ];
    outputBin = "bin";
    outputInclude = "bin";
    outputLib = "bin";
    passthru = previous.passthru // {
      outputToPatterns = previous.passthru.outputToPatterns // {
        bin = [ "*" ];
      };
    };
  });
  hostCudart = cuda_cudart.__spliced.hostHost or cuda_cudart;
  arch = lib.replaceStrings [ "." ] [ "" ] (lib.head cudaConfig.cudaCapabilities);
  producer = stdenvNoCC.mkDerivation {
    name = "${cudaNamePrefix}-tests-nvcc-outputs-producer";
    outputs = [
      "out"
      "cxxdev"
    ];
    strictDeps = true;
    nativeBuildInputs = [ nvcc ];
    cudaPropagateDependenciesToOutput = "cxxdev";
    buildCommand = ''
      test "$CUDA_BIN_PATH" = '${nvcc.bin}/bin'
      mkdir "$out" "$cxxdev"
      runHook postFixup
    '';
  };
  directBin = stdenvNoCC.mkDerivation {
    name = "${cudaNamePrefix}-tests-nvcc-outputs-bin";
    strictDeps = true;
    nativeBuildInputs = [ nvcc.bin ];
    buildInputs = [ zlib ];
    buildCommand = ''
      test "$CUDACXX" = '${lib.getExe nvcc}'
      test "$CUDA_BIN_PATH" = '${nvcc.bin}/bin'
      test "$NIX_CUDA_COMPILER_ROOT" = '${nvcc.bin}'
      test -z "''${NIX_CUDA_MAJOR_MINOR_VERSION_FOR_BUILD-}"
      test ! -e '${nvcc}/nix-support/cuda-component'
      # The compiler's TARGET runtime becomes data for this consumer's HOST.
      [[ " ''${pkgsHostHost[*]} " == *' ${hostCudart} '* ]]
      [[ $NIX_CFLAGS_COMPILE == *'${lib.getInclude hostCudart}/include'* ]]

      mkdir -p "$out"
      cat > saxpy.cu <<'CUDA'
      #include <cuda/std/type_traits>
      #ifdef TEST_ZLIB
      #include <zlib.h>
      extern "C" const char* dependencyVersion() { return zlibVersion(); }
      #endif
      __global__ void saxpy(int n, float a, const float *x, float *y) {
        int i = blockIdx.x * blockDim.x + threadIdx.x;
        if (i < n) y[i] = a * x[i] + y[i];
      }
      extern "C" int runSaxpy(int n, float a, const float *x, float *y) {
        saxpy<<<(n + 255) / 256, 256>>>(n, a, x, y);
        return cudaDeviceSynchronize();
      }
      CUDA
      "$CUDACXX" -c -DTEST_ZLIB -arch=sm_${arch} -Xcompiler=-fPIC saxpy.cu -o saxpy.o
      "$CUDACXX" -shared -arch=sm_${arch} --cudart=shared saxpy.o -lz -o "$out/with-zlib.so"

      # The moved profile and private ar alias must also work outside stdenv.
      compile() {
        env -i HOME="$TMPDIR" TMPDIR="$TMPDIR" \
          PATH=${
            lib.makeBinPath [
              buildPackages.coreutils
              buildPackages.bash
            ]
          } \
          ${lib.getExe nvcc} "$@"
      }
      compile -lib -arch=sm_${arch} saxpy.o -o "$out/libsaxpy.a"
      compile -shared -arch=sm_${arch} -Xcompiler=-fPIC --cudart=shared \
        saxpy.cu -o "$out/saxpy.so"
    '';
  };
in
# Automatic CUDA propagation keeps the metadata-bearing bin output. It must
# retain activation even when the producer used the ordinary aggregate input.
directBin.overrideAttrs {
  name = "${cudaNamePrefix}-tests-nvcc-outputs";
  nativeBuildInputs = [ ];
  buildInputs = [
    producer.cxxdev
    zlib
  ];
  passthru.tests.direct-bin = directBin;
}
