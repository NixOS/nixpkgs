{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, pythonRelaxDepsHook
, setuptools
, pytz
, websockets
, pytest-asyncio
, pytest-mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "bluecurrent-api";
  version = "1.2.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vr6mehGRXHW+fP2luLpD14igCdIgJI5NXzaa+bEife0=";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
    setuptools
  ];

  pythonRemoveDeps = [
    "asyncio"
  ];

  propagatedBuildInputs = [
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
