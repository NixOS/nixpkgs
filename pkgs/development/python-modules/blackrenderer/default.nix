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
  version = "0.8.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "BlackFoundryCom";
    repo = "black-renderer";
    tag = "v${version}";
    hash = "sha256-6mC+JSg0u2hwi7SDFHBoUYCu8sYisWSCOuaTtc0FXi4=";
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
    "Tests/test_canvas_api.py"
    "Tests/test_compareImages.py"
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
