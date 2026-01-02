{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "systemd-lsp";
  version = "2025.12.30";

  src = fetchFromGitHub {
    owner = "JFryy";
    repo = "systemd-lsp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iDVyWV+j1zdcF5Fpl1X7y/itHNLg3cxcvi4UrDrgicg=";
  };

  cargoHash = "sha256-D8XkMzh6dxXGGrDpkREUl0RkN/vhbw9uQYtqdiTcfBE=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Language server implementation for systemd unit files made in Rust";
    homepage = "https://github.com/JFryy/systemd-lsp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mahyarmirrashed ];
    mainProgram = "systemd-lsp";
  };
})
