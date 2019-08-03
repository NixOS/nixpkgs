{ lib, fetchPypi, buildPythonPackage
, pyaes, pycrc }:

buildPythonPackage rec {
  pname = "broadlink";
  version = "0.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "10dnd859yjh1h6qrxhvkslbsj5fh5g654xsq2yqblkkv3xd711rs";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace pyaes==1.6.0 pyaes
    '';

  propagatedBuildInputs = [ pyaes pycrc ];

  # no tests available
  doCheck = false;

  meta = with lib; {
    description = "Python API for controlling Broadlink IR controllers";
    homepage =  https://github.com/mjg59/python-broadlink;
    license = licenses.mit;
  };
}
