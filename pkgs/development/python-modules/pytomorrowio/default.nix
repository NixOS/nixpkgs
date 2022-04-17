{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, aiohttp
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytomorrowio";
  version = "0.2.1";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "aabb41436fb5834b687d73b334d95be07a18d5943d27a1fd06271b749558ba0e";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  checkInputs = [
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
