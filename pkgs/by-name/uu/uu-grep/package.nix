{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uu-grep";
  version = "0.2.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "grep";
    tag = finalAttrs.version;
    hash = "sha256-mVdepwWeAAgbyeZdKwUVhIFJN1fVfx0iMzH0yDdZy8A=";
  };

  cargoHash = "sha256-yzdvdpesG8DhArCaiGvIvEd+oItDrSOMxioGmPcApxg=";

  meta = {
    changelog = "https://github.com/uutils/grep/releases/tag/${finalAttrs.version}";
    description = "Rewrite of grep in Rust";
    homepage = "https://github.com/uutils/grep";
    license = lib.licenses.mit;
    mainProgram = "grep";
    maintainers = with lib.maintainers; [ kyehn ];
    platforms = lib.platforms.unix;
  };
})
