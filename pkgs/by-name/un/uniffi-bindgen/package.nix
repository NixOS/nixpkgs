{
  lib,
  rustPlatform,
  fetchCrate,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uniffi-bindgen";
  version = "0.32.2";
  __structuredAttrs = true;

  src = fetchCrate {
    pname = "uniffi";
    inherit (finalAttrs) version;
    hash = "sha256-uqjfflRbwGPJmgpc7+3K6zJbzFsLRpOvEwPXKHMJSR8=";
  };

  cargoHash = "sha256-Rk1SuDY3Oyu6Hp1Bo1ftGg10CakHXUMolVOSJ3VVfrA=";

  buildFeatures = [ "cli" ];

  # The only tests are a trybuild UI test, whose pinned rustc diagnostics don't
  # match nixpkgs' rustc, and an integration test that hardcodes the upstream
  # monorepo's source path, which the published crate doesn't have.
  doCheck = false;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Multi-language bindings generator for Rust";
    homepage = "https://mozilla.github.io/uniffi-rs";
    changelog = "https://github.com/mozilla/uniffi-rs/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ _223740 ];
    mainProgram = "uniffi-bindgen";
  };
})
