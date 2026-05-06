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
  version = "1.5.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "xet-core";
    tag = finalAttrs.version;
    hash = "sha256-W48PKYVDpfPzT7wM8W2tQmz01BcM1v6rpENuwUvy4Sw=";
  };

  sourceRoot = "${finalAttrs.src.name}/hf_xet";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs)
      pname
      version
      src
      sourceRoot
      ;
    hash = "sha256-agZMRkUdPGX4A9K6em9XHABhAp5aPLaxqYMuTsE10GA=";
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
