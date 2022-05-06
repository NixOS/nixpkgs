{ lib
, aiohttp
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "advantage-air";
  version = "0.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "advantage_air";
    inherit version;
    hash = "sha256-C+cB6oHmbr9mHZKnbls42yenQy3+L8huLk9wKazIWfU=";
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
