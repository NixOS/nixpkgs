{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pysensibo";
  version = "1.0.22";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "andrey-git";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-AUcdKcdoYCg8OgUcFoLLpNK5GQMTg89XCR5CkTfNkcc=";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  # No tests implemented
  doCheck = false;

  pythonImportsCheck = [
    "pysensibo"
  ];

  meta = with lib; {
    description = "Module for interacting with Sensibo";
    homepage = "https://github.com/andrey-git/pysensibo";
    changelog = "https://github.com/andrey-git/pysensibo/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
