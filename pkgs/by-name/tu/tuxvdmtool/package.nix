{
  fetchFromGitHub,
  lib,
  nix-update-script,
  rustPlatform,
}:

rustPlatform.buildRustPackage {
  pname = "tuxvdmtool";
  version = "0-unstable-2026-01-26";

  src = fetchFromGitHub {
    owner = "AsahiLinux";
    repo = "tuxvdmtool";
    rev = "9a23e6260db4f721ffcebba13b604c1fbeb9191b";
    hash = "sha256-Jo0lz3AEnaIKEpHSCTxQK/0jRdJR/a453PGXPAUJDXs=";
  };

  cargoHash = "sha256-bnBtchG87ya7nlf20Zv3htnZDN5jv29DKY+8nx5CK5o=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Apple Silicon to Apple Silicon VDM utility";
    homepage = "https://github.com/AsahiLinux/tuxvdmtool";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "tuxvdmtool";
    platforms = lib.platforms.linux;
  };
}
