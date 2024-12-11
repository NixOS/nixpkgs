{
  lib,
  fetchFromGitHub,
  llvmPackages_17,
  lld_17,
  python3,
  cmake,
  boost,
  libxml2,
  libffi,
  makeWrapper,
  config,
  cudaPackages,
  rocmPackages_6,
  ompSupport ? true,
  openclSupport ? false,
  rocmSupport ? config.rocmSupport,
  cudaSupport ? config.cudaSupport,
  autoAddDriverRunpath,
  callPackage,
  nix-update-script,
}:
let
  inherit (llvmPackages) stdenv;
  rocmPackages = rocmPackages_6;
  llvmPackages = llvmPackages_17;
  lld = lld_17;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "adaptivecpp";
  version = "24.06.0";

  src = fetchFromGitHub {
    owner = "AdaptiveCpp";
    repo = "AdaptiveCpp";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-TPa2DT66bGQ9VfSXaFUDuE5ng5x5fiLC2bqQ+ZVo9LQ=";
  };

  nativeBuildInputs =
    [
      cmake
      makeWrapper
    ]
    ++ lib.optionals cudaSupport [
      autoAddDriverRunpath
      cudaPackages.cuda_nvcc
    ];

  buildInputs =
    [
      libxml2
      libffi
      boost
      llvmPackages.openmp
      llvmPackages.libclang.dev
      llvmPackages.llvm
    ]
    ++ lib.optionals rocmSupport [
      rocmPackages.clr
      rocmPackages.rocm-runtime
    ]
    ++ lib.optionals cudaSupport [
      cudaPackages.cuda_cudart
      (lib.getOutput "stubs" cudaPackages.cuda_cudart)
    ];

  # adaptivecpp makes use of clangs internal headers. Its cmake does not successfully discover them automatically on nixos, so we supply the path manually
  cmakeFlags =
    [
      "-DCLANG_INCLUDE_PATH=${llvmPackages.libclang.dev}/include"
      (lib.cmakeBool "WITH_CPU_BACKEND" ompSupport)
      (lib.cmakeBool "WITH_CUDA_BACKEND" cudaSupport)
      (lib.cmakeBool "WITH_ROCM_BACKEND" rocmSupport)
    ]
    ++ lib.optionals (lib.versionAtLeast finalAttrs.version "24") [
      (lib.cmakeBool "WITH_OPENCL_BACKEND" openclSupport)
    ];

  # this hardening option breaks rocm builds
  hardeningDisable = [ "zerocallusedregs" ];

  passthru = {
    # For tests
    inherit (finalAttrs) nativeBuildInputs buildInputs;

    tests = {
      sycl = callPackage ./tests.nix { };
    };

    updateScript = nix-update-script { };
  };

  meta = with lib; {
    homepage = "https://github.com/AdaptiveCpp/AdaptiveCpp";
    description = "Multi-backend implementation of SYCL for CPUs and GPUs";
    maintainers = with maintainers; [ yboettcher ];
    license = licenses.bsd2;
  };
})
