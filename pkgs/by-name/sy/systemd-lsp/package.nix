{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "systemd-lsp";
  version = "2026.01.06";

  src = fetchFromGitHub {
    owner = "JFryy";
    repo = "systemd-lsp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wTqbktVaGUk3/cJ3oH1GXvddqVKJQe09sRiyaU+cqCg=";
  };

  cargoHash = "sha256-2+0+VeHEsUyTivDU7FQbm44RZe0t0hsVHNN2fplDlRI=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Language server implementation for systemd unit files made in Rust";
    homepage = "https://github.com/JFryy/systemd-lsp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mahyarmirrashed ];
    mainProgram = "systemd-lsp";
  };
})
