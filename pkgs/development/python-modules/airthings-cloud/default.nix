{ lib
, aiohttp
, async-timeout
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "airthings-cloud";
  version = "0.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "pyAirthings";
    rev = version;
    hash = "sha256-sqHNK6biSWso4uOYimzU7PkEn0uP5sHAaPGsS2vSMNY=";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "airthings"
  ];

  meta = with lib; {
    description = "Python module for Airthings";
    homepage = "https://github.com/Danielhiversen/pyAirthings";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
