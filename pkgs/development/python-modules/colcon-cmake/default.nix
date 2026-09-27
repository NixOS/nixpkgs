{
  buildPythonPackage,
  lib,
  fetchFromGitHub,
  # build-system
  setuptools,
  # dependencies
  colcon,
  colcon-library-path,
  colcon-test-result,
  packaging,
  # tests
  pytestCheckHook,
  scspell,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "colcon-cmake";
  version = "0.2.29";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "colcon";
    repo = pname;
    tag = version;
    hash = "sha256-v91UREVifYnwbMcM819B5CsXl8FbAH61Ydzu0vXBPX8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    colcon
    colcon-library-path
    colcon-test-result
    packaging
  ];

  nativeCheckInputs = [
    pytestCheckHook
    scspell
    writableTmpDirAsHomeHook
  ];

  disabledTestPaths = [
    # Skip the linter tests that require additional dependencies
    "test/test_flake8.py"
  ];

  pythonImportsCheck = [ "colcon_cmake" ];

  meta = {
    description = "An extension for colcon-core to support CMake projects.";
    homepage = "https://colcon.readthedocs.io/en/released/";
    downloadPage = "https://github.com/colcon/colcon-cmake";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ amronos ];
  };
}
