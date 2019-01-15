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
  version = "6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "505253854f607f2abf4d16092c61d4e9d511a3b4392e60bff957a68592b04369";
  };

  propagatedBuildInputs = [ six pillow pymaging_png ];
  checkInputs = [ mock ];

  meta = with stdenv.lib; {
    description = "Quick Response code generation for Python";
    homepage = "https://pypi.python.org/pypi/qrcode";
    license = licenses.bsd3;
  };

}
