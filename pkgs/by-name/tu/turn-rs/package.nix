{
  rustPlatform,
  lib,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
}:

rustPlatform.buildRustPackage rec {
  pname = "turn-rs";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "mycrl";
    repo = "turn-rs";
    tag = "v${version}";
    hash = "sha256-4I4mjG/euBL08v4xZdnrI8aTGVo5z2F2FDYtxKW1Qt8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-qSYGcZdMn7uelufs6z1UQtLxrRbBGNf3o1a1jR+qiqo=";

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
