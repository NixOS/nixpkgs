{
  lib,
  buildPythonPackage,
  chardet,
  fetchPypi,
  freetype,
  pillow,
  setuptools,
  glibcLocales,
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
  version = "4.2.0";
  pyproject = true;

  # See https://bitbucket.org/pypy/compatibility/wiki/reportlab%20toolkit
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-R0+yjWNDGl1H11yQ1YA5MFDffUkaCceHffMpGi6fbQo=";
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

  nativeBuildInputs = [ setuptools ];

  buildInputs = [ ft ];

  propagatedBuildInputs = [
    chardet
    pillow
  ];

  nativeCheckInputs = [ glibcLocales ];

  checkPhase = ''
    runHook preCheck
    pushd tests
    LC_ALL="en_US.UTF-8" ${python.interpreter} runAll.py
    popd
    runHook postCheck
  '';

  meta = with lib; {
    description = "Open Source Python library for generating PDFs and graphics";
    homepage = "https://www.reportlab.com/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
