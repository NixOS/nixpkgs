{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  rustPlatform,
}:

buildPythonPackage (finalAttrs: {
  pname = "pure-magic-rs";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "qjerome";
    repo = "magic-rs";
    tag = "pure-magic-rs-v${finalAttrs.version}";
    hash = "sha256-l8+mbMvX1Od/A2O0e4oaknCT48ON9juSPkkrY8Hu0B0=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-Tpj3mNH6QtnOy8fHoW+ckwEzfyxE4Q/5qESl1DAAAOE=";
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
