{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, aiohttp
, pytest-aiohttp
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytomorrowio";
  version = "0.3.4";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-d4twa9bHaQ9XTHSb8pwJnnJ7tDH6vGpck3/8Y39tRaY=";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  checkInputs = [
    pytest-aiohttp
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pytomorrowio" ];

  meta = {
    description = "Async Python package to access the Tomorrow.io API";
    homepage = "https://github.com/raman325/pytomorrowio";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
