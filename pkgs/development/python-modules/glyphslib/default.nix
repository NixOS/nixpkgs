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
  version = "6.0.7";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "glyphsLib";
    rev = "v${version}";
    sha256 = "sha256-PrHK9uEgs0DcNYW6EQ5Qw29CN4R2OcxOHrMeIswsxdA=";
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

  checkInputs = [ pytestCheckHook ];

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

