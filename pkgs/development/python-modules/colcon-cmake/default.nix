{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  # build-system
  setuptools,
  # dependencies
  colcon,
  colcon-devtools,
  packaging,
  colcon-library-path,
  colcon-test-result,
  # tests
  pytestCheckHook,
  pytest-cov-stub,
  scspell,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "colcon-cmake";
  version = "0.2.29";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "colcon";
    repo = "colcon-cmake";
    tag = version;
    hash = "sha256-v91UREVifYnwbMcM819B5CsXl8FbAH61Ydzu0vXBPX8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    colcon
    colcon-devtools
    packaging
    colcon-library-path
  ];

  nativeCheckInputs = [
    colcon-test-result
    pytestCheckHook
    pytest-cov-stub
    scspell
    writableTmpDirAsHomeHook
  ];

  disabledTestPaths = [
    # Skip the linter tests that require additional dependencies
    "test/test_flake8.py"
  ];

  pythonImportsCheck = [ "colcon_devtools" ];

  pythonRemoveDeps = [
    # We use pytest-cov-stub instead (and it is not a runtime dependency anyways)
    "pytest-cov"
  ];

  meta = {
    description = "Extension for colcon to support CMake packages";
    homepage = "https://colcon.readthedocs.io/en/released/";
    downloadPage = "https://github.com/colcon/colcon-cmake";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ guelakais ];
  };
}
