{ lib
, buildPythonPackage
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
  version = "3.6.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-sTzr9OOXu6FFQrzQIzOLb/LBUaOhKqvKie7L+XLLNho=";
  };

  patches = [
    ./darwin-m1-compat.patch
  ];

  nativeCheckInputs = [ glibcLocales ];

  buildInputs = [ ft pillow ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "mif = findFile(d,'ft2build.h')" "mif = findFile('${lib.getDev ft}','ft2build.h')"

    # Remove all the test files that require access to the internet to pass.
    rm tests/test_lib_utils.py
    rm tests/test_platypus_general.py
    rm tests/test_platypus_images.py

    # Remove the tests that require Vera fonts installed
    rm tests/test_graphics_render.py
    rm tests/test_graphics_charts.py
  '';

  checkPhase = ''
    cd tests
    LC_ALL="en_US.UTF-8" ${python.interpreter} runAll.py
  '';

  # See https://bitbucket.org/pypy/compatibility/wiki/reportlab%20toolkit
  disabled = isPyPy;

  meta = {
    description = "An Open Source Python library for generating PDFs and graphics";
    homepage = "http://www.reportlab.com/";
  };
}
