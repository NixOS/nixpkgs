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
  version = "6.4.1";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "glyphsLib";
    rev = "refs/tags/v${version}";
    hash = "sha256-pDFPn1KDiZ5yw1UzPgi0+Syv3h606bsOOzLbdOiag8s=";
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

