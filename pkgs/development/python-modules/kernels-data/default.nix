{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
}:

buildPythonPackage (finalAttrs: {
  pname = "kernels-data";
  version = "0.16.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "kernels";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mrPGykU07PwelebEitr0HDZemZ8WzBhMflBBirQnzAQ=";
  };

  sourceRoot = "${finalAttrs.src.name}/kernels-data/bindings/python";
  cargoRoot = "../../..";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs)
      pname
      version
      src
      sourceRoot
      cargoRoot
      ;
    hash = "sha256-ItMTFRgAk+hthmOsNVIlBIQReiY5ZMviR1Zp8pzL2QA=";
  };

  build-system = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  env.CARGO_TARGET_DIR = "target";

  pythonImportsCheck = [ "kernels_data" ];

  meta = {
    description = "Kernels data structures";
    homepage = "https://github.com/huggingface/kernels";
    changelog = "https://github.com/huggingface/kernels/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ osbm ];
  };
})
