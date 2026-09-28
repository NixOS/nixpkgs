{
  lib,
  fetchFromGitHub,
  rustPlatform,
  stdenv,
  versionCheckHook,
  writeShellApplication,
  curl,
  yq-go,
  common-updater-scripts,
  nix,
  nix-update,
}:

let
  crateVersion = "0.2.0";
  releaseDate = "2026.08.03";
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "systemd-lsp";
  version = "${crateVersion}-${releaseDate}";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "JFryy";
    repo = "systemd-lsp";
    tag = "v${releaseDate}";
    hash = "sha256-yMUUtcSpXn02zbxcljbkzT02DUEJPQBwCopmDxbTmR4=";
  };

  postPatch = ''
    substituteInPlace tests/cli_tests.rs \
      --replace-fail 'target/release' \
                     "target/${stdenv.hostPlatform.rust.cargoShortTarget}/$cargoBuildType"
  '';

  cargoHash = "sha256-2+JTKSzreTmdUiv++WaG8kVV2hXDn6qeY9Cp7n51MP4=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  preVersionCheck = ''
    version=${crateVersion}
  '';

  passthru = {
    inherit crateVersion releaseDate;

    updateScript = lib.getExe (writeShellApplication {
      name = "${finalAttrs.pname}-update-script";
      runtimeInputs = [
        curl
        yq-go
        common-updater-scripts
        nix
        nix-update
      ];
      text = builtins.readFile ./update.bash;
    });
  };

  meta = {
    description = "Language server implementation for systemd unit files made in Rust";
    homepage = "https://github.com/JFryy/systemd-lsp";
    changelog = "https://github.com/JFryy/systemd-lsp/releases/tag/v${releaseDate}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mahyarmirrashed ];
    mainProgram = "systemd-lsp";
    platforms = with lib.platforms; unix ++ windows;
  };
})
