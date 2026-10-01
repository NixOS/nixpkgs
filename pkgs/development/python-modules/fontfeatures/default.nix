{
  lib,
  babelfont,
  buildPythonPackage,
  fetchPypi,
  fonttools,
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

  dependencies = [
    fonttools
    lxml
  ];

  optional-dependencies.shaper = [
    babelfont
    youseedee
  ];

  nativeCheckInputs = [ pytestCheckHook ];
  disabledTestPaths = [
    # These tests require babelfont but we have to leave it out and skip them
    # to break the cyclic dependency with babelfont.
    "tests/test_shaping_generic.py"
    "tests/test_shaping_harfbuzz.py"
  ];

  meta = {
    description = "Python library for compiling OpenType font features";
    homepage = "https://github.com/simoncozens/fontFeatures";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ danc86 ];
  };
}
