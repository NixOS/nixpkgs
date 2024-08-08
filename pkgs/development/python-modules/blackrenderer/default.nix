{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gitUpdater,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
  fonttools,
  uharfbuzz,
  skia-python,
  numpy,
  pycairo,
  pillow,
}:

buildPythonPackage rec {
  pname = "blackrenderer";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "BlackFoundryCom";
    repo = "black-renderer";
    rev = "v${version}";
    hash = "sha256-b2W0M32Y4HUyxObjvh0yMUBe5gfcSDXnw1GfhW7hoZk=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    fonttools
    uharfbuzz
  ];

  optional-dependencies = {
    skia = [
      skia-python
      numpy
    ];
    cairo = [ pycairo ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pillow
  ];

  disabledTestPaths = [
    "Tests/test_glyph_render.py"
    "Tests/test_mainprog.py"
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Renderer for OpenType COLR fonts, with multiple backends";
    homepage = "https://github.com/BlackFoundryCom/black-renderer";
    license = lib.licenses.asl20;
    mainProgram = "blackrenderer";
    maintainers = with lib.maintainers; [ jopejoe1 ];
  };
}
