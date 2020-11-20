{ lib, fetchPypi, buildPythonPackage
, cryptography, pyaes, pycrc }:

buildPythonPackage rec {
  pname = "broadlink";
  version = "0.16.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "637dabc6f47b283b72bc521322554462da7a247f04614e458d65df8574d03a41";
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
