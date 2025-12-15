{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "vivid";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = "vivid";
    rev = "v${version}";
    hash = "sha256-mxBBfezaMM2dfiXK/s+Htr+i5GJP1xVSXzkmYxEuwNs=";
  };

  cargoHash = "sha256-oP5/G/PSkwn4JruLQOGtM8M2uPt4Q88bU3kNmXUK4JE=";

  meta = {
    description = "Generator for LS_COLORS with support for multiple color themes";
    homepage = "https://github.com/sharkdp/vivid";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = [ lib.maintainers.dtzWill ];
    platforms = lib.platforms.unix;
    mainProgram = "vivid";
  };
}
