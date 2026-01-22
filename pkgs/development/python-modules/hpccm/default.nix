{
  lib,
  archspec,
  buildPythonPackage,
  fetchFromGitHub,
  packaging,
  pytest-xdist,
  pytestCheckHook,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "hpccm";
  version = "26.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "hpc-container-maker";
    tag = "v${version}";
    hash = "sha256-ITmq031/I4nKU4te9hio/H03Kz1IAfqTejDWUfsGL+g=";
  };

  build-system = [ setuptools ];

  dependencies = [
    six
    archspec
    packaging
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
  ];

  disabledTests = [
    # tests require git
    "test_commit"
    "test_tag"
  ];

  pythonImportsCheck = [ "hpccm" ];

  meta = {
    description = "HPC Container Maker";
    homepage = "https://github.com/NVIDIA/hpc-container-maker";
    changelog = "https://github.com/NVIDIA/hpc-container-maker/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ atila ];
    mainProgram = "hpccm";
    platforms = lib.platforms.x86;
  };
}
