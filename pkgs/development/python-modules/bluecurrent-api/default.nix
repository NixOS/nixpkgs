{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, setuptools
, pytz
, websockets
, pytest-asyncio
, pytest-mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "bluecurrent-api";
  version = "1.2.3";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mWRTSMS68+J1Z4PYOFF/UvofSqV1wv0gjiTACEWDfNg=";
  };

  build-system = [
    setuptools
  ];

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
