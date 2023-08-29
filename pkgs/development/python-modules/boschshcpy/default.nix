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
  version = "0.2.67";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tschamm";
    repo = pname;
    rev = version;
    hash = "sha256-M0LyEKJUcamv0PcflVI97zrXAoe1iV5sJ/oh60bMo6c=";
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
