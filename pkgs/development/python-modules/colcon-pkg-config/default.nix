{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  colcon,
  pylint,
  pytest-cov,
  pytestCheckHook,
  setuptools,
  scspell,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "colcon-pkg-config";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "colcon";
    repo = "colcon-pkg-config";
    tag = version;
    hash = "sha256-CCtRZ4hBfF+StTsr9tV+mGCqGhHk7GQ0JWIV4ZaCtN8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    colcon
  ];

  nativeCheckInputs = [
    pylint
    pytest-cov
    pytestCheckHook
    scspell
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [
    "colcon_pkg_config"
  ];

  disabledTestPaths = [
    "test/test_flake8.py"
  ];

  meta = {
    description = "Extension for colcon-core adding environment variable to find pkg-config files";
    homepage = "http://colcon.readthedocs.io/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ guelakais ];
  };
}
