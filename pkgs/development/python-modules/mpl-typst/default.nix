{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  matplotlib,
  numpy,
  pytestCheckHook,
  pillow,
  nix-update-script,
  typst,
}:

buildPythonPackage rec {
  pname = "mpl-typst";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "daskol";
    repo = "mpl-typst";
    tag = "v${version}";
    hash = "sha256-RVzovICoDqEnjq0HngSe4vLlPszSgkq1FF0/Jrnw34Y=";
  };

  postPatch = ''
    # make hermetic
    substituteInPlace mpl_typst/config.py \
      --replace-fail \
        "get_typst_compiler(name: str, default=Path('typst'))" \
        "get_typst_compiler(name: str, default=Path('${lib.getExe typst}'))"
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    matplotlib
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pillow
    numpy
  ];

  pytestFlags = [ "-v" ];

  pythonImportsCheck = [
    "mpl_typst"
    "mpl_typst.as_default"
  ];

  disabledTestPaths = [
    # These render generated Typst through the typst binary. The prologue
    # imports @preview/based, so Typst attempts to download a package in the
    # Nix sandbox.
    "mpl_typst/backend_test.py::TestTypstRenderer::test_draw_path"
    "mpl_typst/backend_test.py::TestTypstRenderer::test_draw_path_clips_to_bbox"
    "mpl_typst/backend_test.py::TestTypstRenderer::test_draw_path_bbox_pixels"
    "mpl_typst/backend_test.py::TestTypstRenderer::test_draw_path_hatched_rect_pixels"
    "mpl_typst/backend_test.py::TestTypstRenderer::test_draw_path_hatched_rect_pixels_golden"
    "mpl_typst/backend_test.py::TestTypstRenderer::test_draw_text_colored"
    "mpl_typst/backend_test.py::TestTypstRenderer::test_draw_image_lenna"
    "mpl_typst/backend_test.py::TestTypstRenderer::test_draw_image_spy"
    "tests/regression/issue32_test.py::TestIssue32::test_reference"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # fatal error when matplotlib creates a canvas
    "mpl_typst/backend_test.py"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Typst backend for matplotlib";
    homepage = "https://github.com/daskol/mpl-typst";
    changelog = "https://github.com/daskol/mpl-typst/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ genga898 ];
  };
}
