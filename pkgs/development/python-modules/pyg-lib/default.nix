{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cmake,
  ninja,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  torch,
  triton,
}:

let
  inherit (torch) cudaCapabilities cudaPackages cudaSupport;
  cudaArchitectures = (builtins.map cudaPackages.cudaFlags.dropDot cudaCapabilities);
  cudaArchitecturesString = lib.strings.concatStringsSep ";" cudaArchitectures;
in
buildPythonPackage rec {
  pname = "pyg-lib";
  # unstable version is required to support pytorch 2.3
  version = "0.4.0-unstable-2024-04-29";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pyg-team";
    repo = "pyg-lib";
    rev = "462a835d9593a175f552c093ddc2a19ffdc4e6a8";
    fetchSubmodules = true;
    hash = "sha256-8TUWlBL9L3zVsz3gk11xl9H0FvEvQDh5DtnJ4fW/XOk=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "cmake_args = [" "cmake_args = [ '-DCMAKE_CUDA_ARCHITECTURES=${cudaArchitecturesString}',"
  '';

  dontUseCmakeConfigure = true;

  nativeBuildInputs = lib.optionals cudaSupport (with cudaPackages; [ cuda_nvcc ]);

  build-system = [
    cmake
    ninja
    setuptools
  ];

  env.FORCE_CUDA = if cudaSupport then 1 else 0;

  buildInputs = lib.optionals cudaSupport (
    with cudaPackages;
    [
      cuda_cccl
      cuda_cudart
      cuda_nvrtc
      cuda_nvtx
      libcublas
      libcusolver
      libcusparse
    ]
  );

  dependencies = [
    # implicit dependency
    torch
  ];

  optional-dependencies = {
    triton = [ triton ];
  };

  pythonImportsCheck = [ "pyg_lib" ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    rm -r pyg_lib
  '';

  meta = {
    description = "Low-Level Graph Neural Network Operators for PyG";
    homepage = "https://github.com/pyg-team/pyg-lib";
    changelog = "https://github.com/pyg-team/pyg-lib/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
