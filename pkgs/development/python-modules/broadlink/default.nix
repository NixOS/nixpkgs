{ lib, fetchPypi, buildPythonPackage
, cryptography, pyaes, pycrc }:

buildPythonPackage rec {
  pname = "broadlink";
  version = "0.14.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f771456ed990187f170d1561e2fd3d490ef646a2570a0286fe709a7115abcb49";
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
