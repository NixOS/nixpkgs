{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "turtle-build";
  version = "0.4.8";

  src = fetchFromGitHub {
    owner = "raviqqe";
    repo = "turtle-build";
    rev = "v${version}";
    hash = "sha256-PDpiLPMyBZzj2nBy76cSC4ab/kyaoZC/Gd2HSaRVHUM=";
  };

  cargoHash = "sha256-Z9PCnFrUgvF9anfShfU9U7iYISDpzAuJudLq/wN4ONU=";

  meta = {
    description = "Ninja-compatible build system for high-level programming languages written in Rust";
    homepage = "https://github.com/raviqqe/turtle-build";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ figsoda ];
    mainProgram = "turtle";
  };
}
