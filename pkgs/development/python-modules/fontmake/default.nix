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
  version = "3.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-njJArNq7nhdoq0Si3+RUDE+VJSwuUvk+e7WeuNaluK0=";
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
