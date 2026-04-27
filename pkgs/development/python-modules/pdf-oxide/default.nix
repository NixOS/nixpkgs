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

  pythonImportsCheck = [
    "pdf_oxide"
  ];

  meta = pkgs.pdf-oxide.meta // {
    description = "Python bindings for the pdf_oxide library";
  };
})
