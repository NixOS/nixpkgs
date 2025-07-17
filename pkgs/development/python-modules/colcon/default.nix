{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  # build-system
  setuptools,
  # dependencies
  distlib,
  empy,
  packaging,
  python-dateutil,
  pyyaml,
  # tests
  pytestCheckHook,
  pytest-cov-stub,
  pytest-repeat,
  pytest-rerunfailures,
}:
buildPythonPackage rec {
  pname = "colcon-core";
  version = "0.19.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "colcon";
    repo = "colcon-core";
    tag = version;
    hash = "sha256-R/TVHPT305PwaVSisP0TtbgjCFBwCZkXOAgkYhCKpyY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    empy
    distlib
    packaging
    python-dateutil
    pyyaml
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    pytest-repeat
    pytest-rerunfailures
  ];

  disabledTestPaths = [
    # Skip the linter and spell check tests that require additional dependencies
    "test/test_flake8.py"
    "test/test_spell_check.py"
  ];

  pythonImportsCheck = [ "colcon_core" ];

  pythonRemoveDeps = [
    # We use pytest-cov-stub instead (and it is not a runtime dependency anyways)
    "pytest-cov"
  ];

  meta = {
    description = "Command line tool to build sets of software packages";
    homepage = "https://github.com/colcon/colcon-core";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ guelakais ];
    mainProgram = "colcon";
  };
}
