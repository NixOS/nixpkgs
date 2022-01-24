{ lib
, buildPythonPackage
, fetchPypi
, cryptography
}:

buildPythonPackage rec {
  pname = "broadlink";
  version = "0.18.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c66b3e4a097d6549f0fcc9ccdf289bd88f73f647ad9449e1c4e2958301ad1b04";
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
