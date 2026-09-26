{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  rustPlatform,
}:

buildPythonPackage (finalAttrs: {
  pname = "pure-magic-rs";
  version = "0.5.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "qjerome";
    repo = "magic-rs";
    tag = "pure-magic-rs-v${finalAttrs.version}";
    hash = "sha256-9YYspquAyBTxHmRUJ2qrmgpndtyTa4A7rwSA6HAqM5M=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-sNQfWaWoN+VUSB9DVtt4MTwsxCEZQ3lzyIv9Fwi/Kfw=";
  };

  buildAndTestSubdir = "python";

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pure_magic_rs" ];

  meta = {
    description = "Safe Rust implementation of libmagic";
    homepage = "https://github.com/qjerome/magic-rs";
    license =
      with lib.licenses;
      OR [
        gpl3Only
        bsd2
      ];
    maintainers = with lib.maintainers; [ fab ];
  };
})
