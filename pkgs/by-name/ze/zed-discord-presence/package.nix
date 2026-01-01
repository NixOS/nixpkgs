{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zed-discord-presence";
<<<<<<< HEAD
  version = "0.9.2";
=======
  version = "0.9.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "xhyrom";
    repo = "zed-discord-presence";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-BvhAt4tA3efu2XHQLEA0eTNInol0fWRiCtzBplLDzMo=";
  };

  cargoBuildFlags = [ "--package discord-presence-lsp" ];
  cargoHash = "sha256-/25WO/zTgQPuctXowRtVF1GxXdmJzsL5HjhLaxcj0Ao=";
=======
    hash = "sha256-tbtccnG81YrDVk4vY1yImjiezIQrBAhVWdZs7MmUAog=";
  };

  cargoBuildFlags = [ "--package discord-presence-lsp" ];
  cargoHash = "sha256-HNyxaiX+nHnWqu3TZmNbmazT9GkQTukbHTz+7kJXEDo=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
