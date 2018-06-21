{ stdenv, buildPythonPackage, fetchPypi, pillow, poppler_utils }:

buildPythonPackage rec {
  pname = "pdf2image";
  version = "0.1.14";

  buildInputs = [ pillow poppler_utils ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "2926ebbf327e909d594619e520a1986c18d0cf60ae62acc7ebc503ccdef21f0f";
  };

  meta = with stdenv.lib; {
    description = "A python module that wraps the pdftoppm utility to convert PDF to PIL Image object";
    homepage = https://github.com/Belval/pdf2image;
    license = licenses.mit;
    maintainers = with maintainers; [ gerschtli ];
    platforms = platforms.all;
  };
}
