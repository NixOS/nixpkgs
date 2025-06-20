{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zed-discord-presence";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "xhyrom";
    repo = "zed-discord-presence";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6KpjJajibMY7pBR5XhZf2KPBkBMkdcYKutifNdF3Hko=";
  };

  cargoBuildFlags = [ "--package discord-presence-lsp" ];
  cargoHash = "sha256-2hQHhrbUYKDtFX8ZiDpVYrd9/g6bCi9XL0VwKDWFE+s=";

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
