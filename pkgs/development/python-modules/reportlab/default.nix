{ lib
, buildPythonPackage
, pythonOlder
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
  version = "3.6.10";

  disabled = pythonOlder "3.7";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bf8cba95a2d5cf731e8b74c92b4f07d79ef286a2a78b617300e37e51cf955cb2";
  };

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

  buildInputs = [ ft ];

  propagatedBuildInputs = [ pillow ];

  checkPhase = ''
    runHook preCheck

    cd tests
    ${python.interpreter} runAll.py

    runHook postCheck
  '';

  meta = {
    description = "An Open Source Python library for generating PDFs and graphics";
    homepage = "http://www.reportlab.com/";
    changelog = "https://hg.reportlab.com/hg-public/reportlab/file/tip/CHANGES.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
