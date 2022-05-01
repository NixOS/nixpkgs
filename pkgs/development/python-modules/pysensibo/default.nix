{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pysensibo";
  version = "1.0.13";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "andrey-git";
    repo = pname;
    rev = version;
    hash = "sha256-GMzO29UHlRxFDPMfVtPiOCYkdjGm1lfdl6oZdk4ujTY=";
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
