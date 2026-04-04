{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pkg-config,
  rustPlatform,
  openssl,
}:

buildPythonPackage (finalAttrs: {
  pname = "hf-xet";
  version = "1.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "xet-core";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UdHEpJztlVI8LPs8Ne9sKe1Nv3kVVk4YLxQ3W8sUPbQ=";
  };

  sourceRoot = "${finalAttrs.src.name}/hf_xet";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs)
      pname
      version
      src
      sourceRoot
      ;
    hash = "sha256-GV+XY5uV57yQWVGdRLpGU3eD8Gz2gy6p7OHlF+mlJI4=";
  };

  nativeBuildInputs = [
    pkg-config
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  buildInputs = [
    openssl
  ];

  env.OPENSSL_NO_VENDOR = 1;

  pythonImportsCheck = [ "hf_xet" ];

  # No tests (yet?)
  doCheck = false;

  meta = {
    description = "Xet client tech, used in huggingface_hub";
    homepage = "https://github.com/huggingface/xet-core/tree/main/hf_xet";
    changelog = "https://github.com/huggingface/xet-core/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
