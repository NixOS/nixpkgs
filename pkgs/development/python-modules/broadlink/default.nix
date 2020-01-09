{ lib, fetchPypi, buildPythonPackage
, cryptography, pyaes, pycrc }:

buildPythonPackage rec {
  pname = "broadlink";
  version = "0.12.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6448327f8f1cd0c103971a724a3e60629ccb5e8c302e7fdcbde6464e8edef2d8";
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
    homepage =  https://github.com/mjg59/python-broadlink;
    license = licenses.mit;
  };
}
