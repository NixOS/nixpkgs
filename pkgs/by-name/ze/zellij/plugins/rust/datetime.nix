{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zellij-datetime";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "h1romas4";
    repo = "zellij-datetime";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hMkzhP+4r6PLeJBOr6AZlvC+qn2HOiwQYdakOr8bkHE=";
  };

  cargoHash = "sha256-ZakKWSS/lUXafLJtVwQfOMAOyqs45n9xe+V7Bp4e/Qg=";

  meta = {
    description = "Add a date and time pane to Zellij";
    homepage = "https://github.com/h1romas4/zellij-datetime";
    changelog = "https://github.com/h1romas4/zellij-datetime/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
  };
})
