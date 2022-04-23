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
  version = "0.3.3";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0d4f81dc90aefa26da18b927473cb7b08b093f7732301983ef5f0b1ca1181c62";
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
