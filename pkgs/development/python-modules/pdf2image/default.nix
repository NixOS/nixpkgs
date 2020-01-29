{ stdenv, buildPythonPackage, fetchPypi, pillow, poppler_utils }:

buildPythonPackage rec {
  pname = "pdf2image";
  version = "1.10.0";

  propagatedBuildInputs = [ pillow poppler_utils ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "0bpprn5wcz414pqpvwjpd5cc0838shkw2cfvrwfiilhr09bhxbhb";
  };

  meta = with stdenv.lib; {
    description = "A python module that wraps the pdftoppm utility to convert PDF to PIL Image object";
    homepage = https://github.com/Belval/pdf2image;
    license = licenses.mit;
    maintainers = with maintainers; [ gerschtli ];
    platforms = platforms.all;
  };
}
