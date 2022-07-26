{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pysensibo";
  version = "1.0.18";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "andrey-git";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-sFEeN72+h6yFQFluhOQfxoVJPB5lCpFnlJfLnRxVjFg=";
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
