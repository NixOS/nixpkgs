{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-cov-stub,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  requests,
  responses,
  setuptools,
}:

buildPythonPackage rec {
  pname = "python-tado";
  version = "0.18.6";
  pyproject = true;

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "wmalgadey";
    repo = "PyTado";
    tag = version;
    hash = "sha256-pDT159TY1PEG3TLoIaNy5VVpIklclgOvFy4W5HKy7uM=";
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

  meta = with lib; {
    description = "Python binding for Tado web API. Pythonize your central heating!";
    homepage = "https://github.com/wmalgadey/PyTado";
    changelog = "https://github.com/wmalgadey/PyTado/releases/tag/${src.tag}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jamiemagee ];
    mainProgram = "pytado";
  };
}
