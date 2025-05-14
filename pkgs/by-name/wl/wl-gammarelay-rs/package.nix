{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "wl-gammarelay-rs";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "MaxVerevkin";
    repo = "wl-gammarelay-rs";
    rev = "v${version}";
    hash = "sha256-zmtC4xNNAK/TiB5TU6qsY5y0Z3roaEnTwHMZPjq6SbE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-UVkNA+AsW8pbT8UhlsoeddOwO+XUO/+y0q4VwzkY/D8=";

  meta = {
    description = "Simple program that provides DBus interface to control display temperature and brightness under wayland without flickering";
    homepage = "https://github.com/MaxVerevkin/wl-gammarelay-rs";
    license = lib.licenses.gpl3Plus;
    mainProgram = "wl-gammarelay-rs";
    maintainers = with lib.maintainers; [ quantenzitrone ];
    platforms = lib.platforms.unix;
    badPlatforms = lib.platforms.darwin;
  };
}
