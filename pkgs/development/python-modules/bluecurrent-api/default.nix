{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  pytz,
  websockets,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "bluecurrent-api";
  version = "1.2.4";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "bluecurrent";
    repo = "HomeAssistantAPI";
    tag = "v${version}";
    hash = "sha256-NirWs06CkiSE3HPomQwBmX+XFhBxsM6ffE72mvlfxoY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pytz
    websockets
  ];

  pythonImportsCheck = [ "bluecurrent_api" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  meta = {
    description = "Wrapper for the Blue Current websocket api";
    homepage = "https://github.com/bluecurrent/HomeAssistantAPI";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
