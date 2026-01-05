{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-cov-stub,
  pytest-mock,
  pytestCheckHook,
  requests,
  responses,
  setuptools,
}:

buildPythonPackage rec {
  pname = "python-tado";
  version = "0.18.15";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wmalgadey";
    repo = "PyTado";
    tag = version;
    hash = "sha256-FUnD5JVS816XQYqXGSDnypqcYuKVhEeFIFcENf8BkcU=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytest-mock
    pytestCheckHook
    responses
  ];

  disabledTests = [
    # network access
    "test_interface_with_tado_api"
  ];

  disabledTestPaths = [
    # network access
    "tests/test_my_tado.py"
    "tests/test_my_zone.py"
  ];

  pythonImportsCheck = [ "PyTado" ];

  meta = {
    description = "Python binding for Tado web API";
    homepage = "https://github.com/wmalgadey/PyTado";
    changelog = "https://github.com/wmalgadey/PyTado/releases/tag/${src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ jamiemagee ];
    mainProgram = "pytado";
  };
}
