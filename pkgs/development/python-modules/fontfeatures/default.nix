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
}:

buildPythonPackage rec {
  pname = "fontfeatures";
  version = "1.8.0";
  format = "setuptools";

  src = fetchPypi {
    pname = "fontFeatures";
    inherit version;
    hash = "sha256-XLJD91IyUUjeSqdhWFfIqv9yISPcbU4bgRvXETSHOiY=";
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
