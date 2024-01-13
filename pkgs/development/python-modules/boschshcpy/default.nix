{ lib
, buildPythonPackage
, cryptography
, fetchFromGitHub
, getmac
, pythonOlder
, requests
, setuptools
, zeroconf
}:

buildPythonPackage rec {
  pname = "boschshcpy";
  version = "0.2.88";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "tschamm";
    repo = "boschshcpy";
    rev = "refs/tags/${version}";
    hash = "sha256-tyx7VJGsU9YYNJQy1mly0AgwKULZ1BWeRzz1BDgXrUU=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    cryptography
    getmac
    requests
    zeroconf
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "boschshcpy"
  ];

  meta = with lib; {
    description = "Python module to work with the Bosch Smart Home Controller API";
    homepage = "https://github.com/tschamm/boschshcpy";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
