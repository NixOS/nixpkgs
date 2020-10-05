{ lib, fetchPypi, buildPythonPackage
, cryptography, pyaes, pycrc }:

buildPythonPackage rec {
  pname = "broadlink";
  version = "0.15.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "521a388b1621a8a13bb65f50a4bbf18f964676c129d5e12cd2ffe0bda57fb4ae";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace pyaes==1.6.0 pyaes
    '';

  propagatedBuildInputs = [ cryptography pyaes pycrc ];

  # no tests available
  doCheck = false;

  meta = with lib; {
    description = "Python API for controlling Broadlink IR controllers";
    homepage =  "https://github.com/mjg59/python-broadlink";
    license = licenses.mit;
  };
}
