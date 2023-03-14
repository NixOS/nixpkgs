{ lib
, aiohttp
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "advantage-air";
  version = "0.4.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "advantage_air";
    inherit version;
    hash = "sha256-3t6ujBmhDVghnDSmJWb/7CHKNsvr4QFsfIqd4p8BHlA=";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  # No tests
  doCheck = false;

  pythonImportsCheck = [
    "advantage_air"
  ];

  meta = with lib; {
    description = "API helper for Advantage Air's MyAir and e-zone API";
    homepage = "https://github.com/Bre77/advantage_air";
    license = licenses.mit;
    maintainers = with maintainers; [ jamiemagee ];
  };
}
