{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  cattrs,
  fontmath,
  fonttools,
  glyphslib,
  setuptools,
  setuptools-scm,
  skia-pathops,
  ttfautohint-py,
  ufo2ft,
  ufolib2,
}:

buildPythonPackage (finalAttrs: {
  pname = "fontmake";
  version = "3.12.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "fontmake";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dgforezrilmD2d6MFY3Z5X/82yPRfSW/I/OxXcZ+xJw=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    fontmath
    fonttools
    glyphslib
    ufo2ft
    ufolib2
  ]
  ++ fonttools.optional-dependencies.ufo
  ++ fonttools.optional-dependencies.lxml
  ++ fonttools.optional-dependencies.unicode
  ++ ufo2ft.optional-dependencies.compreffor;

  optional-dependencies = {
    pathops = [ skia-pathops ];
    lxml = [ ];
    mutatormath = [ ];
    autohint = [ ttfautohint-py ];
    json = ufolib2.optional-dependencies.json;
    repacker = fonttools.optional-dependencies.repacker;
  };

  nativeCheckInputs = [
    pytestCheckHook
    cattrs
  ] ++ finalAttrs.passthru.optional-dependencies.autohint;

  pythonImportsCheck = [ "fontmake" ];

  meta = {
    description = "Compiles fonts from various sources (.glyphs, .ufo, designspace) into binaries formats (.otf, .ttf)";
    homepage = "https://github.com/googlefonts/fontmake";
    changelog = "https://github.com/googlefonts/fontmake/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jopejoe1 ];
  };
})
