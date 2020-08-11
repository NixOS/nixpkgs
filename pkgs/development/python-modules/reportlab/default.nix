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
  version = "3.5.46";

  src = fetchPypi {
    inherit pname version;
    sha256 = "56d71b78e7e4bb31a93e1dff13c22d19b7fb3890b021a39b6c3661b095bd7de8";
  };

  checkInputs = [ glibcLocales ];

  buildInputs = [ ft pillow ];

  postPatch = ''
    # Remove all the test files that require access to the internet to pass.
    rm tests/test_lib_utils.py
    rm tests/test_platypus_general.py
    rm tests/test_platypus_images.py

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
    homepage = "http://www.reportlab.com/";
  };
}
