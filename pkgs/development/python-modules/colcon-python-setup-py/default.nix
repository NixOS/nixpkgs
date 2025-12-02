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
  pname = "colcon-python-setup-py";
  version = "0.2.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "colcon";
    repo = "colcon-python-setup-py";
    tag = version;
    hash = "sha256-N+OL0rSoWwZZioMV9JRvrQHdahE3fY7kKjfflUiRVL8=";
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
    "colcon_python_setup_py"
  ];

  disabledTestPaths = [
    "test/test_flake8.py"
  ];

  meta = {
    description = "Extension for colcon-core to support Python packages with the metadata in the setup.py file";
    homepage = "https://colcon.readthedocs.io/";
    downloadPage = "https://github.com/colcon/colcon-python-setup-py";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ guelakais ];
  };
}
