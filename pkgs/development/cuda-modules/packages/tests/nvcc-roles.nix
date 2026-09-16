{
  backendStdenv,
  cuda_cudart,
  cuda_nvcc,
  cudaMajorMinorVersion,
  cudaNamePrefix,
  libcublas,
  lib,
  pkgs,
  zlib,
}:
let
  # Different CUDA releases make accidental mixing of BUILD and HOST headers
  # observable even on native systems. Cross builds also check CPU codegen.
  buildCuda =
    if lib.versions.major cudaMajorMinorVersion == "12" then
      pkgs.cudaPackages_13
    else
      pkgs.cudaPackages_12_9;
  elfMachine = platform: if platform.isAarch64 then "AArch64" else "Advanced Micro Devices X86-64";
in
backendStdenv.mkDerivation {
  name = "${cudaNamePrefix}-tests-nvcc-roles";
  __structuredAttrs = true;
  strictDeps = true;
  dontUnpack = true;
  dontStrip = true;
  outputs = [
    "out"
    "build"
  ];

  depsBuildBuild = [
    buildCuda.cuda_nvcc
    buildCuda.cuda_cudart
    buildCuda.libcublas
    zlib
  ];
  nativeBuildInputs = [ cuda_nvcc ];
  buildInputs = [
    cuda_cudart
    libcublas
    zlib
  ];

  buildPhase = ''
    runHook preBuild
    test "$CUDACXX_FOR_BUILD" != "$CUDACXX"
    test "$NIX_CUDA_MAJOR_MINOR_VERSION_FOR_BUILD" != "$NIX_CUDA_MAJOR_MINOR_VERSION"
    test -z "$NVCC_PREPEND_FLAGS"

    cp ${../saxpy/src/saxpy.cu} saxpy.cu
    chmod +w saxpy.cu
    sed -i '1i#include <zlib.h>' saxpy.cu
    substituteInPlace saxpy.cu \
      --replace-fail 'int main(void) {' 'int main(void) { puts(zlibVersion());'
    # A device-side launch requires cudadevrt at the device-link step. Host
    # linking alone does not exercise NVCC's library-search-path adaptation.
    sed -i '/^int main(void)/i __global__ void dispatch(int n, float a, float *x, float *y) { saxpy<<<(n + 255) / 256, 256>>>(n, a, x, y); }' saxpy.cu
    sed -i 's/saxpy<<<(N + 255) \/ 256, 256>>>/dispatch<<<1, 1>>>/' saxpy.cu

    # Compiler-wrapper flags are whitespace-separated, including newlines.
    export NIX_LDFLAGS_FOR_BUILD=$'\n'"$NIX_LDFLAGS_FOR_BUILD"
    export NIX_LDFLAGS=$'\n'"$NIX_LDFLAGS"

    # Both invocations share one environment. The wrapper must select its own
    # role's SDK and backend without the caller swapping global variables.
    "$CUDACXX_FOR_BUILD" -v -arch=sm_80 -rdc=true --cudart shared -lcublas -lz \
      saxpy.cu -o saxpy-build
    # Empty overrides also mean to use the default backend.
    CUDAHOSTCXX= NVCC_CCBIN= "$CUDACXX" -v -arch=sm_80 -rdc=true --cudart shared -lcublas -lz \
      saxpy.cu -o saxpy-host

    "$READELF" -h saxpy-build | grep -F 'Machine:' | grep -F '${elfMachine backendStdenv.buildPlatform}'
    "$READELF" -h saxpy-host | grep -F 'Machine:' | grep -F '${elfMachine backendStdenv.hostPlatform}'
    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall
    mkdir -p "$out/bin" "$build/bin"
    cp saxpy-host "$out/bin/saxpy"
    cp saxpy-build "$build/bin/saxpy"
    runHook postInstall
  '';
}
