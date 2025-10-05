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
  version = "2025.09.0";

  src = fetchFromGitHub {
    owner = "LLNL";
    repo = "umpire";
    tag = "v${version}";
    hash = "sha256-1lJty4HdjwExBih7Bl3E34LpmDlDlhb0zl9N7MyFj5w=";
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

  meta = with lib; {
    description = "Application-focused API for memory management on NUMA & GPU architectures";
    homepage = "https://github.com/LLNL/Umpire";
    maintainers = with maintainers; [ sheepforce ];
    license = with licenses; [ mit ];
    platforms = [ "x86_64-linux" ];
  };
}
