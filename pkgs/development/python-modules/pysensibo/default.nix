{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pysensibo";
  version = "1.0.12";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "andrey-git";
    repo = pname;
    rev = version;
    hash = "sha256-gXdyVEBcYCUOo8PHzsJLkjtnX1B1iRS/DAxdQDU3HaY=";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [
    "pysensibo"
  ];

  meta = with lib; {
    description = "Module for interacting with Sensibo";
    homepage = "https://github.com/andrey-git/pysensibo";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
