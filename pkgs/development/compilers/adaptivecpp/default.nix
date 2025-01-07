{
  lib,
  fetchFromGitHub,
  llvmPackages_17,
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
  symlinkJoin,
  nix-update-script,
}:
let
  inherit (llvmPackages) stdenv;
  rocmPackages = rocmPackages_6;
  llvmPackages = llvmPackages_17;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "adaptivecpp";
  version = "24.10.0";

  src = fetchFromGitHub {
    owner = "AdaptiveCpp";
    repo = "AdaptiveCpp";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-ZwHDiwv1ybC+2UhiOe2f7fnfqcul+CD9Uta8PT9ICr4=";
  };

  # we may be able to get away with just wrapping hipcc and nothing more
  # this is mainly so that if acpp tries doing <PATH_TO_HIPCC>/../amdgcn/bitcode
  rocmMerged = symlinkJoin {
    name = "rocm-merged";
    paths = with rocmPackages; [
      clr
      rocm-core
      rocm-device-libs
      rocm-runtime
    ];
    buildInputs = [ makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/hipcc \
        --add-flags "--rocm-device-lib-path=$out/amdgcn/bitcode"
    '';
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
      python3
      llvmPackages.openmp
      llvmPackages.libclang.dev
      llvmPackages.llvm
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
      (lib.cmakeBool "WITH_OPENCL_BACKEND" openclSupport)
    ]
    ++ lib.optionals rocmSupport [
      "-DHIPCC_COMPILER=${finalAttrs.rocmMerged}/bin/hipcc"
      "-DROCM_PATH=${finalAttrs.rocmMerged}"
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
    mainProgram = "acpp";
    maintainers = with maintainers; [ yboettcher ];
    license = licenses.bsd2;
  };
})
