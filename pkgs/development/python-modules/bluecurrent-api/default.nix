{
  lib,
  buildPythonPackage,
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
  version = "1.3.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bluecurrent";
    repo = "HomeAssistantAPI";
    tag = "v${version}";
    hash = "sha256-px4kZOvMUP5aGOQ1uxWnY6w77Woie/hVVdyylW8uSX4=";
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
