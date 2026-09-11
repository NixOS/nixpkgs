{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-sed";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "sed";
    tag = finalAttrs.version;
    hash = "sha256-y1X9nj/quBtisp+6MHFjVKFHrdFnujWTxLWNLvdrADA=";
  };

  cargoHash = "sha256-N5wwNPjOL3U4bPSONGpjmOBU31Nt/sCVth+JH3xmz/g=";

  meta = {
    changelog = "https://github.com/uutils/sed/releases/tag/${finalAttrs.version}";
    description = "Rewrite of sed in Rust";
    homepage = "https://github.com/uutils/sed";
    license = lib.licenses.mit;
    mainProgram = "sed";
    maintainers = with lib.maintainers; [ kyehn ];
    platforms = lib.platforms.unix;
  };
})
