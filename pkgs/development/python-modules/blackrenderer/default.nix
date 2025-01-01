{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
  fonttools,
  uharfbuzz,
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
    tag = "v${version}";
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
    cairo = [ pycairo ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pillow
  ];

  disabledTestPaths = [
    # Wants None existing fonts
    "Tests/test_mainprog.py"
    "Tests/test_glyph_render.py"
  ];

  pythonImportsCheck = [ "blackrenderer" ];

  meta = {
    description = "Renderer for OpenType COLR fonts, with multiple backends";
    homepage = "https://github.com/BlackFoundryCom/black-renderer";
    changelog = "https://github.com/BlackFoundryCom/black-renderer/releases/tag/v${version}";
    license = lib.licenses.asl20;
    mainProgram = "blackrenderer";
    maintainers = with lib.maintainers; [ jopejoe1 ];
  };
}
