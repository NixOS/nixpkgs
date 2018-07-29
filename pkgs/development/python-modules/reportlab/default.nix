{ buildPythonPackage
, fetchPypi
, freetype
, pillow
, glibcLocales
, python
, isPyPy
}:

let
  ft = freetype.overrideAttrs (oldArgs: { dontDisableStatic = true; });
in buildPythonPackage rec {
  pname = "reportlab";
  version = "3.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08986267eaf25d62c3802512f0a97dc3426d0c82f52c8beb576689582eb85b7f";
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