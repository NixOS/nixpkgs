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
  version = "3.5.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3836a49e7ea7bce458f437cbc094633c7fd4ac027180565875c18ecc726f261e";
  };

  checkInputs = [ glibcLocales ];

  buildInputs = [ ft pillow ];

  postPatch = ''
    # Remove all the test files that require access to the internet to pass.
    rm tests/test_lib_utils.py
    rm tests/test_platypus_general.py

    # Remove the tests that require Vera fonts installed
    rm tests/test_graphics_render.py
  '';

  checkPhase = ''
    cd tests
    LC_ALL="en_US.UTF-8" ${python.interpreter} runAll.py
  '';

  # See https://bitbucket.org/pypy/compatibility/wiki/reportlab%20toolkit
  disabled = isPyPy;

  meta = {
    description = "An Open Source Python library for generating PDFs and graphics";
    homepage = http://www.reportlab.com/;
  };
}
