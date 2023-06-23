{
  fetchFromGitHub,
  fetchpatch,
  lib,
  stdenv,
  # nativeBuildInputs
  blas,
  cmake,
  ninja,
  python3,
  # buildInputs
  asmjit,
  cpuinfo,
  # checkInputs
  gbenchmark,
  gtest,
  # Configuration options
  buildSharedLibs ? true,
}: let
  setBool = bool:
    if bool
    then "ON"
    else "OFF";
  setBuildSharedLibrary = bool:
    if bool
    then "shared"
    else "static";
in
  stdenv.mkDerivation (finalAttrs: {
    strictDeps = true;
    pname = "FBGEMM";
    version = finalAttrs.src.rev;
    src = fetchFromGitHub {
      owner = "pytorch";
      repo = finalAttrs.pname;
      rev = "eea011607fed1b8f2527dca3385fed94001d4227";
      fetchSubmodules = true;
      hash = "sha256-PiMd+3EDKRJ/RrU3B9yduEK+lbVt2k2miRMx+ys+PSc=";
    };
    patches = [
      (fetchpatch {
        url = "https://github.com/pytorch/FBGEMM/pull/1859.patch";
        hash = "sha256-htt1oDTLet1t9QUUcChf7pbC+WgMwnvMDB4xaWjh/D0=";
      })
    ];
    nativeBuildInputs = [
      cmake
      ninja
      python3
    ];
    buildInputs = [
      blas
      asmjit
      cpuinfo
    ];
    # NOTE: GPU-enabled FBGEMM has a dependency on libtorch. Unfortunately,
    # libtorch itself depends on FBGEMM. I (@connorbaker) don't know how to cleanly
    # resolve this circular dependency, so I'm just going to disable GPU support.
    # NOTE: There's no real USE_CUDA flag. FBGEMM uses USE_ROCM to determine if
    # it should use CUDA or ROCm.
    cmakeFlags = [
      "-DUSE_SYSTEM_LIBS:BOOL=ON"
      "-DFBGEMM_BUILD_BENCHMARKS:BOOL=${setBool finalAttrs.doCheck}"
      "-DFBGEMM_BUILD_FBGEMM_GPU:BOOL=OFF"
      "-DFBGEMM_BUILD_TESTS:BOOL=${setBool finalAttrs.doCheck}"
      "-DFBGEMM_LIBRARY_TYPE:STRING=${setBuildSharedLibrary buildSharedLibs}"
    ];
    # To avoid installing the benchmarks and test libraries, set doCheck to false.
    doCheck = true;
    checkInputs = [
      gbenchmark
      gtest
    ];
    passthru = {inherit blas;};
    meta = with lib; {
      description = "Low-precision, high-performance matrix-matrix multiplications and convolution library for server-side inference";
      homepage = "https://github.com/pytorch/FBGEMM";
      license = licenses.bsd2;
      maintainers = with maintainers; [connorbaker];
      platforms = platforms.all;
    };
  })
