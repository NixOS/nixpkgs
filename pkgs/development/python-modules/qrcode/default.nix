{ stdenv
, buildPythonPackage
, fetchPypi
, six
, pillow
, pymaging_png
, mock
}:

buildPythonPackage rec {
  pname = "qrcode";
  version = "5.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0kljfrfq0c2rmxf8am57333ia41kd0snbm2rnqbdy816hgpcq5a1";
  };

  propagatedBuildInputs = [ six pillow pymaging_png ];
  checkInputs = [ mock ];

  meta = with stdenv.lib; {
    description = "Quick Response code generation for Python";
    homepage = "https://pypi.python.org/pypi/qrcode";
    license = licenses.bsd3;
  };

}
