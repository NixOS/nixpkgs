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
  version = "1.3.1";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "bluecurrent";
    repo = "HomeAssistantAPI";
    tag = "v${version}";
    hash = "sha256-PX0pD7X0o7OVtlz4Q5KuDBH83jtTaIdMnuLvAMTP8+U=";
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
