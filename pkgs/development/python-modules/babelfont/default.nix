{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cu2qu,
  defcon,
  fontfeatures,
  fonttools,
  glyphslib,
  openstep-plist,
  orjson,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
  ufolib2,
  vfblib,
}:

buildPythonPackage rec {
  pname = "babelfont";
  version = "3.0.5";
  pyproject = true;

  # PyPI source tarballs omit tests, fetch from Github instead
  src = fetchFromGitHub {
    owner = "simoncozens";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-9PEOkkm7qH4ExiJJKrTZX5Ph/urtOyFsy7jjtFepncU=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    cu2qu
    fontfeatures
    fonttools
    glyphslib
    openstep-plist
    orjson
    ufolib2
    vfblib
  ];

  nativeCheckInputs = [
    defcon
    pytestCheckHook
  ];

  # Want non exsiting test data
  disabledTests = [
    "test_rename"
    "test_rename_nested"
    "test_rename_contextual"
  ];

  disabledTestPaths = [ "tests/test_glyphs3_roundtrip.py" ];

  meta = with lib; {
    description = "Python library to load, examine, and save fonts in a variety of formats";
    mainProgram = "babelfont";
    homepage = "https://github.com/simoncozens/babelfont";
    license = licenses.bsd3;
    maintainers = with maintainers; [ danc86 ];
  };
}
