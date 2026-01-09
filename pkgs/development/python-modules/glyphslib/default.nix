{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fonttools,
  openstep-plist,
  ufolib2,
  pytestCheckHook,
  unicodedata2,
  setuptools-scm,
  ufonormalizer,
  xmldiff,
  defcon,
  ufo2ft,
  skia-pathops,
}:

buildPythonPackage rec {
  pname = "glyphslib";
  version = "6.12.6";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "glyphsLib";
    tag = "v${version}";
    hash = "sha256-okN/+/+5k+KOlcInouiadKP8aJVV8yqHZnmucXkQsGM=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    fonttools
    openstep-plist
    ufolib2
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
    changelog = "https://github.com/googlefonts/glyphsLib/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
