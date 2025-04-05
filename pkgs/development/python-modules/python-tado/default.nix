{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-cov-stub,
  pytest-mock,
  pytest-socket,
  pytestCheckHook,
  pythonOlder,
  requests,
  responses,
}:

buildPythonPackage rec {
  pname = "python-tado";
  version = "0.19.2";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "wmalgadey";
    repo = "PyTado";
    tag = version;
    hash = "sha256-me62VPjKU+vh0vo4Fl86sEse1QZYD2zDpxchSiUcxTY=";
  };

  build-system = [ poetry-core ];

  dependencies = [ requests ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytest-mock
    pytest-socket
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
    description = "Python binding for Tado web API";
    homepage = "https://github.com/wmalgadey/PyTado";
    changelog = "https://github.com/wmalgadey/PyTado/releases/tag/${src.tag}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jamiemagee ];
    mainProgram = "pytado";
  };
}
