{ stdenv
, buildPythonPackage
, isPy27
, fetchPypi
, six
, pillow
, pymaging_png
, mock
}:

buildPythonPackage rec {
  pname = "qrcode";
  version = "6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "037b0db4c93f44586e37f84c3da3f763874fcac85b2974a69a98e399ac78e1bf";
  };

  propagatedBuildInputs = [ six pillow pymaging_png ];
  checkInputs = [ mock ];
  doCheck = isPy27; # https://github.com/lincolnloop/python-qrcode/issues/163

  meta = with stdenv.lib; {
    description = "Quick Response code generation for Python";
    homepage = "https://pypi.python.org/pypi/qrcode";
    license = licenses.bsd3;
  };

}
