{ stdenv, buildPythonPackage, fetchPypi, pillow, poppler_utils }:

buildPythonPackage rec {
  pname = "pdf2image";
  version = "1.4.2";

  propagatedBuildInputs = [ pillow poppler_utils ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "694f8014f4c3722e5913f1c378c7056b1330db070ff7cb8196a80d24b80fa61e";
  };

  meta = with stdenv.lib; {
    description = "A python module that wraps the pdftoppm utility to convert PDF to PIL Image object";
    homepage = https://github.com/Belval/pdf2image;
    license = licenses.mit;
    maintainers = with maintainers; [ gerschtli ];
    platforms = platforms.all;
  };
}
