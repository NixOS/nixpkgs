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
  version = "3.9.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KrfT0fvE1fhaM2RH4LqRUda7yMHg2T59UdGi3SSZP7s=";
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
