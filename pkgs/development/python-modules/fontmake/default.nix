{ lib
, buildPythonPackage
, fetchPypi
, glyphslib
, setuptools-scm
, ufo2ft
, fonttools
, fontmath
, lxml
, setuptools
}:

buildPythonPackage rec {
  pname = "fontmake";
  version = "3.7.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Nb09/BRPR0H3rHrbDIhcrgOyJp55KCIdPvUr/vh2Z0U=";
    extension = "zip";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    glyphslib
    ufo2ft
    fonttools
    fontmath
    lxml
    setuptools
  ];

  pythonImportsCheck = [ "fontmake" ];

  meta = {
    description = "Compiles fonts from various sources (.glyphs, .ufo, designspace) into binaries formats (.otf, .ttf)";
    homepage = "https://github.com/googlefonts/fontmake";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.BarinovMaxim ];
  };
}
