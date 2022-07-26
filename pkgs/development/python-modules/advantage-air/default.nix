{ lib
, aiohttp
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "advantage-air";
  version = "0.4.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "advantage_air";
    inherit version;
    hash = "sha256-I9HMDLZX9xKDJuYSAweM2r4v3ZKevHTn5dHTYxN3EuE=";
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
