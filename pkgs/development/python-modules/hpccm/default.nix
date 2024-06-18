{
  lib,
  archspec,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "hpccm";
  version = "23.11.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "hpc-container-maker";
    rev = "refs/tags/v${version}";
    hash = "sha256-uB2+1Nc+SgPzB5hJI1L6yD8gn0hGOkIZF6rejq4rYg8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    six
    archspec
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

  meta = with lib; {
    description = "HPC Container Maker";
    homepage = "https://github.com/NVIDIA/hpc-container-maker";
    changelog = "https://github.com/NVIDIA/hpc-container-maker/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ atila ];
    mainProgram = "hpccm";
    platforms = platforms.x86;
  };
}
