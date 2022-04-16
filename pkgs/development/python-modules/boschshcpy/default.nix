{ lib
, buildPythonPackage
, cryptography
, fetchFromGitHub
, getmac
, pythonOlder
, requests
, zeroconf
}:

buildPythonPackage rec {
  pname = "boschshcpy";
  version = "0.2.31";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tschamm";
    repo = pname;
    rev = version;
    sha256 = "sha256-04qTjwnPckBHKBs9+BFWtTJ9uVc0U1oJAiLIE1nqQdE=";
  };

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
