{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "turtle-build";
  version = "0.4.9";

  src = fetchFromGitHub {
    owner = "raviqqe";
    repo = "turtle-build";
    rev = "v${version}";
    hash = "sha256-sbYDp4r/M6GvCYEshccJ331mVNeN85wwf9TKHiYFv7I=";
  };

  cargoHash = "sha256-JZU0Xam4NPiOHdXDtJsTBjOQnaDWReSZMD33sQxeUzQ=";

  meta = with lib; {
    description = "Ninja-compatible build system for high-level programming languages written in Rust";
    homepage = "https://github.com/raviqqe/turtle-build";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = [ ];
    mainProgram = "turtle";
  };
}
