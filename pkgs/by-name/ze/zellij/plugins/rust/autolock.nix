{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zellij-autolock";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "fresh2dev";
    repo = "zellij-autolock";
    tag = finalAttrs.version;
    hash = "sha256-HnFZgDT3jmjWPqbmHLos5pzwYjudYqeqSeV7t+LYMN0=";
  };

  cargoHash = "sha256-sTzSc/m7JtbDB3xHfcXn7hjzaZJRvAKh1OIHrhLemZo=";

  meta = {
    description = "Autolock Zellij when certain processes open";
    homepage = "https://github.com/fresh2dev/zellij-autolock";
    changelog = "https://github.com/fresh2dev/zellij-autolock/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ilkecan ];
  };
})
