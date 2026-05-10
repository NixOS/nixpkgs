{
  lib,
  pkgs,
  fetchFromGitHub,
  buildPythonPackage,

  # build-system
  rustPlatform,

  # optional-dependencies
  onnxruntime,

  # tests
  pytestCheckHook,
}:
buildPythonPackage (finalAttrs: {
  inherit (pkgs.pdf-oxide)
    pname
    version
    src
    cargoDeps
    ;

  pyproject = true;

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  optional-dependencies = {
    ocr = [ onnxruntime ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # AssertionError: assert (False or False or False)
    "test_version_is_038_or_newer"
    #401: two-font encrypted PDF (19203 B) is too small
    "test_issue_401_two_embedded_fonts_save_encrypted"
  ];

  pythonImportsCheck = [
    "pdf_oxide"
  ];

  meta = pkgs.pdf-oxide.meta // {
    description = "Python bindings for the pdf_oxide library";
  };
})
