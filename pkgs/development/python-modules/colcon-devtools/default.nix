{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  # build-system
  setuptools,
  # dependencies
  colcon,
  packaging,
  # tests
  pytestCheckHook,
  pytest-cov-stub,
  scspell,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "colcon-devtools";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "colcon";
    repo = "colcon-devtools";
    tag = version;
    hash = "sha256-QBkShQ58QHhYtlKtYaj9/Zs8KMy/Cw55lJHM16uNoxI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    colcon
    packaging
  ];

  nativeCheckInputs = [
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
    description = "Extension for colcon to provide information about all extension points and extensions";
    homepage = "https://colcon.readthedocs.io/en/released/";
    downloadPage = "https://github.com/colcon/colcon-devtools";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ guelakais ];
  };
}
