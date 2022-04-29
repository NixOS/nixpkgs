{ lib
, buildPythonPackage
, fetchPypi
, cryptography
, pythonOlder
}:

buildPythonPackage rec {
  pname = "broadlink";
  version = "0.18.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KMfL1mY4th87gjPrdhvzQjdXucgwSChsykOCO3cPAD8=";
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
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
