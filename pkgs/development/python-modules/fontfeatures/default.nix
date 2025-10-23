{
  lib,
  buildPythonPackage,
  fetchPypi,
  beziers,
  fonttools,
  fs,
  glyphtools,
  lxml,
  pytestCheckHook,
  youseedee,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "fontfeatures";
  version = "1.9.0";

  pyproject = true;
  build-system = [ setuptools-scm ];

  src = fetchPypi {
    pname = "fontfeatures";
    inherit version;
    hash = "sha256-3PpUgaTXyFcthJrFaQqeUOvDYYFosJeXuRFnFrwp0R8=";
  };

  propagatedBuildInputs = [
    beziers
    fonttools
    fs
    glyphtools
    lxml
    youseedee
  ];

  nativeCheckInputs = [ pytestCheckHook ];
  disabledTestPaths = [
    # These tests require babelfont but we have to leave it out and skip them
    # to break the cyclic dependency with babelfont.
    "tests/test_shaping_generic.py"
    "tests/test_shaping_harfbuzz.py"
  ];

  meta = with lib; {
    description = "Python library for compiling OpenType font features";
    homepage = "https://github.com/simoncozens/fontFeatures";
    license = licenses.bsd3;
    maintainers = with maintainers; [ danc86 ];
  };
}
