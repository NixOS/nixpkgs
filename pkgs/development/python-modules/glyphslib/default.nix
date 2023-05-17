{ lib
, buildPythonPackage
, fetchFromGitHub
, fonttools
, openstep-plist
, ufoLib2
, pytestCheckHook
, unicodedata2
, setuptools-scm
, ufonormalizer
, xmldiff
, defcon
, ufo2ft
, skia-pathops
}:

buildPythonPackage rec {
  pname = "glyphslib";
  version = "6.1.0";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "glyphsLib";
    rev = "refs/tags/v${version}";
    hash = "sha256-TulMOubqY1hI1No0yW4d9Wo5xjqBm0qXqmo17+Fvq0w=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    fonttools
    openstep-plist
    ufoLib2
    unicodedata2
    ufonormalizer
    xmldiff
    defcon
    ufo2ft
    skia-pathops
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "glyphsLib" ];

  disabledTestPaths = [
    "tests/builder/designspace_gen_test.py" # this test tries to use non-existent font "CoolFoundry Examplary Serif"
    "tests/builder/interpolation_test.py" # this test tries to use a font that previous test should made
  ];

  meta = {
    description = "Bridge from Glyphs source files (.glyphs) to UFOs and Designspace files via defcon and designspaceLib";
    homepage = "https://github.com/googlefonts/glyphsLib";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.BarinovMaxim ];
  };
}

