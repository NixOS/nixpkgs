{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zed-discord-presence";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "xhyrom";
    repo = "zed-discord-presence";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HmSJipRWVB1rXyO5ZK1ksyCLDzSJD820Klo88A7NLx4=";
  };

  cargoBuildFlags = [ "--package discord-presence-lsp" ];
  cargoHash = "sha256-x9sB90jW7v2SGggLILgLbBfFV7DkJazcrUiKAfIroMA=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Discord rich presence for Zed";
    homepage = "https://github.com/xhyrom/zed-discord-presence";
    changelog = "https://github.com/xhyrom/zed-discord-presence/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ bddvlpr ];
    mainProgram = "discord-presence-lsp";
  };
})
