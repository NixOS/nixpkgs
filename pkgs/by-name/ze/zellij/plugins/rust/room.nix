{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "room";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "rvcas";
    repo = "room";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KHCt4U0uqK/qkTGq2/Jf5bqBBhVDqAgFh80RPpU/KY0=";
  };

  cargoHash = "sha256-CtaMzE72YV/DPPhjxL6LCvA03J8MneSOnMdy4mkyXvE=";

  meta = {
    description = "Quickly searching and switching tabs";
    homepage = "https://github.com/rvcas/room";
    changelog = "https://github.com/rvcas/room/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
  };
})
