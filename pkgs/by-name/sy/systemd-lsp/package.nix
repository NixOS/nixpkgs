{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  writeShellApplication,
  curl,
  yq-go,
  common-updater-scripts,
  nix,
  nix-update,
}:

let
  crateVersion = "0.2.1";
  releaseDate = "2026.09.28";
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "systemd-lsp";
  version = "${crateVersion}-${releaseDate}";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "JFryy";
    repo = "systemd-lsp";
    tag = "v${releaseDate}";
    hash = "sha256-ATzepUemul9vWfHFCCAH2yHrhNjsBzTqsjJB2dLi3vE=";
  };

  cargoHash = "sha256-qajr9g7l9Nix9JLZg9yGWx8kn8xAuGC9Yo2Q+4dAS/M=";

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
    changelog = "https://github.com/JFryy/systemd-lsp/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mahyarmirrashed ];
    mainProgram = "systemd-lsp";
    platforms = with lib.platforms; unix ++ windows;
  };
})
