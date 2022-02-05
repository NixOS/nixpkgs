{ lib
, aiohttp
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "advantage-air";
  version = "0.2.6";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "advantage_air";
    inherit version;
    hash = "sha256-n7Vl5fLEpkAEi4NrsoJlwwdaGcxnXURLdGN0etHgmOE=";
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
