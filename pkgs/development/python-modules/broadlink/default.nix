{ lib
, buildPythonPackage
, fetchPypi
, cryptography
, pythonOlder
}:

buildPythonPackage rec {
  pname = "broadlink";
  version = "0.18.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2ktLSJ1Nsdry8dvWmY/BbhHApTYQMvSjCsNKX3PkocU=";
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
