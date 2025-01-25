{
  rustPlatform,
  lib,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
}:

rustPlatform.buildRustPackage rec {
  pname = "turn-rs";
  version = "3.3.2";

  src = fetchFromGitHub {
    owner = "mycrl";
    repo = "turn-rs";
    tag = "v${version}";
    hash = "sha256-ITs6kNI1g7k8bcSSG6GwPGY5U+mFGqCTU6JIEj9mH/Q=";
  };

  cargoHash = "sha256-bmeTDMa/khX7fTDCGpf3U2LZPnkXL+bi69sv6NPnANI=";

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
