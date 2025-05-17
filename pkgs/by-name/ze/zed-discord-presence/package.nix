{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zed-discord-presence";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "xhyrom";
    repo = "zed-discord-presence";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eNwfpmuEhQtlcF1edk9hZKKhI5OMK1EbCp5tlJUY+28=";
  };

  cargoBuildFlags = [ "--package discord-presence-lsp" ];
  cargoHash = "sha256-JLNCEeo9fKeV4vTtPs+Yj2wRO1RKP2fuetrPlXcPBjA=";

  meta = {
    description = "Discord rich presence for Zed";
    homepage = "https://github.com/xhyrom/zed-discord-presence";
    changelog = "https://github.com/xhyrom/zed-discord-presence/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ bddvlpr ];
    mainProgram = "discord-presence-lsp";
  };
})
