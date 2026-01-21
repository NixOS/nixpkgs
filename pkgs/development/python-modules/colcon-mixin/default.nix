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
  pname = "colcon-mixin";
  version = "0.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "colcon";
    repo = "colcon-mixin";
    tag = version;
    hash = "sha256-XQpRDBTtrFOOlCRXKVImUtwrwirO0ELWifUpfQuyrrY=";
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
    "colcon_mixin"
  ];

  disabledTestPaths = [
    "test/test_flake8.py"
  ];

  meta = {
    description = "Extension for colcon-core to provide mixin functionality";
    homepage = "https://github.com/colcon/colcon-mixin";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ guelakais ];
  };
}
