{ lib
, aiohttp
, async-timeout
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "millheater";
  version = "0.11.7";
  format = "setuptools";

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "pymill";
    rev = "refs/tags/${version}";
    hash = "sha256-jqtyJHoG/8tgv4OJleb7DV6C7pCpgplieLykfvO3cNM=";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "mill"
  ];

  meta = with lib; {
    description = "Python library for Mill heater devices";
    homepage = "https://github.com/Danielhiversen/pymill";
    changelog = "https://github.com/Danielhiversen/pymill/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
