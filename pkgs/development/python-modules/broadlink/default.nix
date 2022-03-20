{ lib
, buildPythonPackage
, fetchPypi
, cryptography
}:

buildPythonPackage rec {
  pname = "broadlink";
  version = "0.18.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-KMfL1mY4th87gjPrdhvzQjdXucgwSChsykOCO3cPAD8=";
  };

  propagatedBuildInputs = [
    cryptography
  ];

  # no tests available
  doCheck = false;

  pythonImportsCheck = [
    "broadlink"
  ];

  meta = with lib; {
    description = "Python API for controlling Broadlink IR controllers";
    homepage =  "https://github.com/mjg59/python-broadlink";
    license = licenses.mit;
  };
}
