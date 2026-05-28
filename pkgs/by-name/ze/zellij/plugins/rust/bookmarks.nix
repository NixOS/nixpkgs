{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zellij-bookmarks";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "yaroslavborbat";
    repo = "zellij-bookmarks";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QTQsZsNupWkua0oO2FqicHrK7utavZ+fRCR8dIDBYyU=";
  };

  cargoHash = "sha256-htBt3HQo8P76WludBmBxt/5wKbiGnmCJnJkFoUoMzZ0=";

  meta = {
    description = "Create, manage, and quickly insert command bookmarks into the terminal";
    homepage = "https://github.com/yaroslavborbat/zellij-bookmarks";
    changelog = "https://github.com/yaroslavborbat/zellij-bookmarks/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
  };
})
