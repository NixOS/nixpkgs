{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uniffi-bindgen";
  version = "0.33.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "uniffi-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-K0JqI9VpnR9urSIMxKuAkfiKmAI9qxtNjMK5mJUzZT8=";
  };

  cargoHash = "sha256-etaH85c3SNtRMPxdsL93H5JMOWqV7ojDzhEWQ2Ht7PI=";

  cargoBuildFlags = [
    "-p"
    "uniffi"
  ];
  cargoTestFlags = finalAttrs.cargoBuildFlags;
  buildFeatures = [ "cli" ];

  checkFlags = [
    # trybuild UI test with pinned rustc diagnostics that don't match nixpkgs' rustc
    "--skip=test::trybuild_ui_tests"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Multi-language bindings generator for Rust";
    homepage = "https://mozilla.github.io/uniffi-rs";
    changelog = "https://github.com/mozilla/uniffi-rs/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ _223740 ];
    mainProgram = "uniffi-bindgen";
  };
})
