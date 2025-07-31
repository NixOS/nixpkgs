{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cmake,
  ninja,
  setuptools,

  gitMinimal,

  libgcc,
  llvmPackages,

  # dependencies
  expecttest,
  hypothesis,
  packaging,
  psutil,
  torch,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "intel-extension-for-pytorch";
  version = "2.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "intel";
    repo = "intel-extension-for-pytorch";
    tag = "v${version}+cpu";
    fetchSubmodules = true;
    # leaveDotGit = true;
    deepClone = true;
    # hash = "sha256-WpexEAAQFF95sANpFz6sk0qJ0td1kM+4Q68vSA0H8iY=";
    # hash = "sha256-3wgVSBdsLh+QUu09o8IgRobw9omqLYZMmrtwLcLiSa4=";
    hash = "sha256-rRtRmTlx/18WvbdMIrhskcwDRfDL7pB9RVZsteteB+M=";
  };

  build-system = [
    cmake
    ninja
    setuptools
  ];
  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    gitMinimal
  ];

  buildInputs = [
    (lib.getDev llvmPackages.openmp)
    (lib.getDev libgcc)
  ];

  dependencies = [
    expecttest
    hypothesis
    packaging
    psutil
    setuptools
    torch
  ];

  pythonImportsCheck = [ "intel_extension_for_pytorch" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Python package for extending the official PyTorch that can easily obtain performance on Intel platform";
    homepage = "https://github.com/intel/intel-extension-for-pytorch";
    changelog = "https://github.com/intel/intel-extension-for-pytorch/releases/tag/v${version}%2Bcpu";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
