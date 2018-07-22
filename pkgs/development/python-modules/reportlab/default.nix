{ lib
, buildPythonPackage
, fetchPypi
, freetype
, pillow
, pip
, glibcLocales
, python
, isPyPy
}:

let
  ft = freetype.overrideAttrs (oldArgs: { dontDisableStatic = true; });
in buildPythonPackage rec {
  pname = "reportlab";
  version = "3.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5345494df4f1563fdab5597f7f543eae44c0aeecce05bd4d93c199f34c4b8c0c";
  };

  checkInputs = [ glibcLocales ];

  buildInputs = [ ft pillow ];

  postPatch = ''
    rm tests/test_graphics_barcode.py
    rm tests/test_graphics_render.py
  '';

  checkPhase = ''
    LC_ALL="en_US.UTF-8" ${python.interpreter} tests/runAll.py
  '';

  # See https://bitbucket.org/pypy/compatibility/wiki/reportlab%20toolkit
  disabled = isPyPy;

  meta = {
    description = "An Open Source Python library for generating PDFs and graphics";
    homepage = http://www.reportlab.com/;
  };
}