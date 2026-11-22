{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uniffi-bindgen";
  version = "0.32.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "uniffi-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zIQ2ktwOI3MYnYinGZO52aJhm1l6SELpdNPcQ84KYsc=";
  };

  cargoHash = "sha256-6LdW3ZVYqUilmbCLslhSrTt6eVZr1QLgecGVshONKpU=";

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
