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
  scspell,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "colcon-core";
  version = "0.20.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "colcon";
    repo = "colcon-core";
    tag = version;
    hash = "sha256-FV/G2FcnBgr7mUY/Jr+bVAdEfhHL9qAnpc92hpTfy7Y=";
  };

  # Upstream tracking issue: https://github.com/ros2/ros2/issues/1738
  # This will break some functionality of building setuptools packages using colcon, other package types should work fine
  patches = [ ./0001-update-setuptools.patch ];

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
    scspell
    writableTmpDirAsHomeHook
  ];

  disabledTestPaths = [
    # Skip the linter tests that require additional dependencies
    "test/test_flake8.py"
    # Skip failing Python build tests
    "test/test_build_python.py"
  ];

  pythonImportsCheck = [ "colcon_core" ];

  pythonRemoveDeps = [
    # We use pytest-cov-stub instead (and it is not a runtime dependency anyways)
    "pytest-cov"
    # Upper bound on setuptools is too strict for nixpkgs
    "setuptools"
  ];

  meta = {
    description = "Command line tool to build sets of software packages";
    homepage = "https://github.com/colcon/colcon-core";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      amronos
      guelakais
    ];
    mainProgram = "colcon";
  };
}
