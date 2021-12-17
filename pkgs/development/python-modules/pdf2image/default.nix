{ lib, buildPythonPackage, fetchPypi, pillow, poppler_utils }:

buildPythonPackage rec {
  pname = "pdf2image";
  version = "1.16.0";

  propagatedBuildInputs = [ pillow poppler_utils ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "d58ed94d978a70c73c2bb7fdf8acbaf2a7089c29ff8141be5f45433c0c4293bb";
  };

  meta = with lib; {
    description = "A python module that wraps the pdftoppm utility to convert PDF to PIL Image object";
    homepage = "https://github.com/Belval/pdf2image";
    license = licenses.mit;
    maintainers = with maintainers; [ gerschtli ];
    platforms = platforms.all;
  };
}
