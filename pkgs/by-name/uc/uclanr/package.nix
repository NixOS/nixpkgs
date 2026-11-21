{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uclanr";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "axlefublr";
    repo = "uclanr";
    tag = finalAttrs.version;
    hash = "sha256-hnExkzsrdr+e7Y15IlP6JcC9dXN9We3r64IhFHWz8/U=";
  };

  cargoHash = "sha256-jOBIJAdkKxYy3NqQgbRAPN3OKPXJtQWs/W73g13CBQ8=";

  meta = {
    description = "A random word picker that gives you actually useful words";
    homepage = "https://github.com/Axlefublr/uclanr";
    changelog = "https://github.com/Axlefublr/uclanr/releases/tag/${finalAttrs.version}";
    license = with lib.licenses; [
      mit
    ];
    maintainers = with lib.maintainers; [
      TheSast
    ];
    mainProgram = "uclanr";
    platforms = lib.platforms.all;
  };
})
