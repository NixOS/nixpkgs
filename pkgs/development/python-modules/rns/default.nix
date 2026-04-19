{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, cryptography
, pyserial
, pytestCheckHook
}:

buildPythonPackage rec {
  pname   = "rns";
  version = "1.1.6";
  format  = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-RAXRlzJICFzoR3O4RPOyYWCOB65bSIVubdttpTuZz/4=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    cryptography
    pyserial
  ];

  doCheck = false;

  pythonImportsCheck = [ "RNS" ];

  meta = with lib; {
    description = "Self-configuring, encrypted and resilient mesh networking stack";
    homepage    = "https://reticulum.network";
    changelog   = "https://github.com/markqvist/Reticulum/releases/tag/${version}";
    license     = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms   = platforms.unix;
  };
}
