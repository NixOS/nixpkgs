{
  rustPlatform,
  lib,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
}:

rustPlatform.buildRustPackage rec {
  pname = "turn-rs";
  version = "3.3.3";

  src = fetchFromGitHub {
    owner = "mycrl";
    repo = "turn-rs";
    tag = "v${version}";
    hash = "sha256-kNE6FbHAFVWH04uTJBCRkrB0yzIjuXX3rxi2h5WmKWo=";
  };

  cargoHash = "sha256-D2gvvHal3hRtm0na4nxEPv16m7vIDs1rchfap25ScHk=";

  passthru = {
    updateScript = nix-update-script { };
    tests.nixos = nixosTests.turn-rs;
  };

  meta = {
    description = "Pure rust implemented turn server";
    homepage = "https://github.com/mycrl/turn-rs";
    changelog = "https://github.com/mycrl/turn-rs/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    mainProgram = "turn-server";
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    platforms = lib.platforms.linux;
  };
}
