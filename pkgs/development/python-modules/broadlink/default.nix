{ lib, fetchPypi, buildPythonPackage
, cryptography, pyaes, pycrc }:

buildPythonPackage rec {
  pname = "broadlink";
  version = "0.14.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5c443d4639b737069e5e27df451b6e89c5ed50be81899e4ea02adb355bf3d724";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace pyaes==1.6.0 pyaes
    '';

  requiredPythonModules = [ cryptography pyaes pycrc ];

  # no tests available
  doCheck = false;

  meta = with lib; {
    description = "Python API for controlling Broadlink IR controllers";
    homepage =  "https://github.com/mjg59/python-broadlink";
    license = licenses.mit;
  };
}
