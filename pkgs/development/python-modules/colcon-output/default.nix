{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  colcon,
  pytest-cov-stub,
  pytestCheckHook,
  setuptools,
  scspell,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "colcon-output";
  version = "0.2.14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "colcon";
    repo = "colcon-output";
    tag = version;
    hash = "sha256-Zt8ZG2SZAgS1iXMnu3b2dSoP9IzrwLwMUXVSJWqRV9w=";
  };

  build-system = [ setuptools ];

  dependencies = [
    colcon
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
    scspell
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [
    "colcon_output"
  ];

  disabledTestPaths = [
    "test/test_flake8.py"
  ];

  meta = {
    description = "Extension for colcon-core to customize the output in various ways";
    downloadPage = "https://github.com/colcon/colcon-output";
    homepage = "http://colcon.readthedocs.io/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ guelakais ];
  };
}
