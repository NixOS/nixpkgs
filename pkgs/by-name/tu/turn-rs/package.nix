{
  rustPlatform,
  lib,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
}:

rustPlatform.buildRustPackage rec {
  pname = "turn-rs";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "mycrl";
    repo = "turn-rs";
    rev = "refs/tags/v${version}";
    hash = "sha256-uXMRDgSHrwT6+kejWRSE1WjXO8LaOR+fnffIXcL3A4I=";
  };

  cargoHash = "sha256-gO2vuOQMvl6KYp529k3CYDyma5ECzOr/lcSvP4OpUUo=";

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
