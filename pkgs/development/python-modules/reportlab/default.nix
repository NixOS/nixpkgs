{
  lib,
  buildPythonPackage,
  charset-normalizer,
  fetchPypi,
  freetype,
  pillow,
  setuptools,
  python,
  isPyPy,
}:

let
  ft = freetype.overrideAttrs (oldArgs: {
    dontDisableStatic = true;
  });
in
buildPythonPackage rec {
  pname = "reportlab";
  version = "4.4.5";
  pyproject = true;

  # See https://bitbucket.org/pypy/compatibility/wiki/reportlab%20toolkit
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BFfWQqp233s2sCNTSZBMWNj5xgaockVu0EQ2qvrcFRA=";
  };

  postPatch = ''
    # Remove all the test files that require access to the internet to pass.
    rm tests/test_lib_utils.py
    rm tests/test_platypus_general.py
    rm tests/test_platypus_images.py

    # Remove the tests that require Vera fonts installed
    rm tests/test_graphics_render.py
    rm tests/test_graphics_charts.py
  '';

  build-system = [ setuptools ];

  buildInputs = [ ft ];

  dependencies = [
    charset-normalizer
    pillow
  ];

  checkPhase = ''
    runHook preCheck
    pushd tests
    ${python.interpreter} runAll.py
    popd
    runHook postCheck
  '';

  meta = with lib; {
    changelog = "https://hg.reportlab.com/hg-public/reportlab/file/tip/CHANGES.md";
    description = "Open Source Python library for generating PDFs and graphics";
    homepage = "https://www.reportlab.com/";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
