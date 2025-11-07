{
  cmake,
  cudatoolkit,
  fetchFromGitHub,
  gfortran,
  lib,
  llvmPackages,
  python3Packages,
  stdenv,
  config,
  enableCfp ? true,
  enableCuda ? config.cudaSupport,
  enableFortran ? builtins.elem stdenv.hostPlatform.system gfortran.meta.platforms,
  enableOpenMP ? true,
  enablePython ? true,
  enableUtilities ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zfp";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "LLNL";
    repo = "zfp";
    rev = finalAttrs.version;
    hash = "sha256-iZxA4lIviZQgaeHj6tEQzEFSKocfgpUyf4WvUykb9qk=";
  };

  patches = [
    # part of https://github.com/LLNL/zfp/pull/217
    # Remove distutils
    ./python312.patch
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs =
    lib.optional enableCuda cudatoolkit
    ++ lib.optional enableFortran gfortran
    ++ lib.optional enableOpenMP llvmPackages.openmp
    ++ lib.optionals enablePython (
      with python3Packages;
      [
        cython
        numpy
        python
      ]
    );

  # compile CUDA code for all extant GPUs so the binary will work with any GPU
  # and driver combination. to be ultimately solved upstream:
  # https://github.com/LLNL/zfp/issues/178
  # NB: not in cmakeFlags due to https://github.com/NixOS/nixpkgs/issues/114044
  preConfigure = lib.optionalString enableCuda ''
    cmakeFlagsArray+=(
      "-DCMAKE_CUDA_FLAGS=-gencode=arch=compute_52,code=sm_52 -gencode=arch=compute_60,code=sm_60 -gencode=arch=compute_61,code=sm_61 -gencode=arch=compute_70,code=sm_70 -gencode=arch=compute_75,code=sm_75 -gencode=arch=compute_80,code=sm_80 -gencode=arch=compute_86,code=sm_86 -gencode=arch=compute_87,code=sm_87 -gencode=arch=compute_86,code=compute_86"
    )
  '';

  cmakeFlags = [
  ]
  ++ lib.optional enableCfp "-DBUILD_CFP=ON"
  ++ lib.optional enableCuda "-DZFP_WITH_CUDA=ON"
  ++ lib.optional enableFortran "-DBUILD_ZFORP=ON"
  ++ lib.optional enableOpenMP "-DZFP_WITH_OPENMP=ON"
  ++ lib.optional enablePython "-DBUILD_ZFPY=ON"
  ++ [ "-DBUILD_UTILITIES=${if enableUtilities then "ON" else "OFF"}" ];

  doCheck = true;

  meta = {
    homepage = "https://computing.llnl.gov/projects/zfp";
    description = "Library for random-access compression of floating-point arrays";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.spease ];
    # 64-bit only
    platforms = lib.platforms.aarch64 ++ lib.platforms.x86_64;
    mainProgram = "zfp";
  };
})
