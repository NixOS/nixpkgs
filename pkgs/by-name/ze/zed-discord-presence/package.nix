{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zed-discord-presence";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "xhyrom";
    repo = "zed-discord-presence";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Q8vCCuSMxEdKUP3V4JHHYpwAt8rc9QOg0z2nCu2dUsk=";
  };

  cargoBuildFlags = [ "--package discord-presence-lsp" ];
  cargoHash = "sha256-MxwonmTTc4jF/wyP6cZeJKuoOeFW0a0zDej8uqr/VsI=";

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
