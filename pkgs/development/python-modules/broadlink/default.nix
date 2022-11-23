{ lib
, buildPythonPackage
, fetchPypi
, cryptography
, pythonOlder
}:

buildPythonPackage rec {
  pname = "broadlink";
  version = "0.18.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3+WKuMbH79v2i4wurObKQZowCmFbVsxlQp3aSk+eelg=";
  };

  propagatedBuildInputs = [
    cryptography
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "broadlink"
  ];

  meta = with lib; {
    description = "Python API for controlling Broadlink IR controllers";
    homepage =  "https://github.com/mjg59/python-broadlink";
    changelog = "https://github.com/mjg59/python-broadlink/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
