{ lib, buildPythonPackage, fetchPypi, pillow, poppler }:

buildPythonPackage rec {
  pname = "pdf2image";
  version = "1.14.0";

  propagatedBuildInputs = [ pillow poppler ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "066527e1bf954762fb4369c677ae3bc15f2ce8707eee830cccef8471fde736d7";
  };

  meta = with lib; {
    description = "A python module that wraps the pdftoppm utility to convert PDF to PIL Image object";
    homepage = "https://github.com/Belval/pdf2image";
    license = licenses.mit;
    maintainers = with maintainers; [ gerschtli ];
    platforms = platforms.all;
  };
}
