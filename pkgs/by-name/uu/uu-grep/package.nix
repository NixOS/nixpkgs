{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uu-grep";
  version = "0.2.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "grep";
    tag = finalAttrs.version;
    hash = "sha256-mVdepwWeAAgbyeZdKwUVhIFJN1fVfx0iMzH0yDdZy8A=";
  };

  cargoHash = "sha256-yzdvdpesG8DhArCaiGvIvEd+oItDrSOMxioGmPcApxg=";

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/uutils/grep/releases/tag/${finalAttrs.src.tag}";
    description = "Rewrite of grep in Rust";
    homepage = "https://github.com/uutils/grep";
    license = lib.licenses.mit;
    mainProgram = "grep";
    maintainers = with lib.maintainers; [ kyehn ];
    platforms = lib.platforms.unix;
  };
})
