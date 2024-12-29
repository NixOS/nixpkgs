{
  lib,
  buildPythonPackage,
  docker,
  fetchFromGitHub,
  fetchpatch,
  poetry-core,
  pytest,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pytest-docker-tools";
  version = "3.1.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Jc2k";
    repo = "pytest-docker-tools";
    rev = "refs/tags/${version}";
    hash = "sha256-6F3aSUyDlBBYG1kwOQvey7rujDdK83uJ3Q1dr8Uo1pw=";
  };

  patches = [
    # Switch to poetry-core, https://github.com/Jc2k/pytest-docker-tools/pull/48
    (fetchpatch {
      name = "switch-poetry-core.patch";
      url = "https://github.com/Jc2k/pytest-docker-tools/pull/48/commits/a655e4a32b075e06e89dd907b06bc4ad90703988.patch";
      hash = "sha256-CwCBld7p+bqBfxV9IyxcCvfxXfnUSzCLF2m0ZduIqkU=";
    })
  ];

  build-system = [ poetry-core ];

  buildInputs = [ pytest ];

  dependencies = [ docker ];

  # Tests require a Docker setup
  doCheck = false;

  pythonImportsCheck = [ "pytest_docker_tools" ];

  meta = with lib; {
    description = "Opionated helpers for creating py.test fixtures for Docker integration and smoke testing environments";
    homepage = "https://github.com/Jc2k/pytest-docker-tools";
    changelog = "https://github.com/Jc2k/pytest-docker-tools/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
