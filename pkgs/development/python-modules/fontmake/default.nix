{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
  pytestCheckHook,
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

buildPythonPackage rec {
  pname = "fontmake";
  version = "3.11.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "fontmake";
    tag = "v${version}";
    hash = "sha256-tiZpuucEzqizgzM8Ry/srwjfYMUL3256HZA1l18vRsI=";
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
  ++ fonttools.optional-dependencies.unicode;

  optional-dependencies = {
    pathops = [ skia-pathops ];
    autohint = [ ttfautohint-py ];
    json = ufolib2.optional-dependencies.json;
    repacker = fonttools.optional-dependencies.repacker;
  };

  nativeCheckInputs = [ pytestCheckHook ] ++ optional-dependencies.autohint;

  pythonImportsCheck = [ "fontmake" ];

  meta = {
    description = "Compiles fonts from various sources (.glyphs, .ufo, designspace) into binaries formats (.otf, .ttf)";
    homepage = "https://github.com/googlefonts/fontmake";
    changelog = "https://github.com/googlefonts/fontmake/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
