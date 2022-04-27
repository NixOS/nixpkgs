{ lib
, buildPythonPackage
, fetchPypi
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
  version = "6.0.4";

  format = "pyproject";

  src = fetchPypi {
    pname = "glyphsLib";
    inherit version;
    sha256 = "sha256-PT66n1WEO5FNcwov8GaXT1YNrAi22X4HN7iVNkuehKI=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "glyphsLib" ];

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

