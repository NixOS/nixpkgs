{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ghost";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "vdbulcke";
    repo = "ghost";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3VqDzYOhSiA7PhGvNzHw93r0xGHZMd3HN7HbkCiXkxA=";
  };

  cargoHash = "sha256-YNsZ87NVLNnkX6OyordIaeQvtXbnHfN1kSy5R/FGcGg=";

  meta = {
    description = "Zellij plugin for spawning floating command terminal pane";
    homepage = "https://github.com/vdbulcke/ghost";
    changelog = "https://github.com/vdbulcke/ghost/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
  };
})
