{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  config,
  cudaSupport ? config.cudaSupport,
  cudaPackages ? null,
}:

assert cudaSupport -> cudaPackages != null;

stdenv.mkDerivation rec {
  pname = "umpire";
<<<<<<< HEAD
  version = "2025.12.0";
=======
  version = "2025.09.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "LLNL";
    repo = "umpire";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-9lGI5SKpDIIzZvsG/yKopfXS1PuHOQB9bwSuML2Xh/8=";
=======
    hash = "sha256-1lJty4HdjwExBih7Bl3E34LpmDlDlhb0zl9N7MyFj5w=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
  ]
  ++ lib.optionals cudaSupport [
    cudaPackages.cuda_nvcc
  ];

  buildInputs = lib.optionals cudaSupport (
    with cudaPackages;
    [
      cudatoolkit
      cuda_cudart
    ]
  );

  cmakeFlags = lib.optionals cudaSupport [
    "-DCUDA_TOOLKIT_ROOT_DIR=${cudaPackages.cudatoolkit}"
    "-DENABLE_CUDA=ON"
    (lib.cmakeFeature "CMAKE_CUDA_ARCHITECTURES" cudaPackages.flags.cmakeCudaArchitecturesString)
  ];

  meta = {
    description = "Application-focused API for memory management on NUMA & GPU architectures";
    homepage = "https://github.com/LLNL/Umpire";
    maintainers = with lib.maintainers; [ sheepforce ];
    license = with lib.licenses; [ mit ];
    platforms = lib.platforms.linux;
  };
}
