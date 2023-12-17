{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "wl-gammarelay-rs";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "MaxVerevkin";
    repo = "wl-gammarelay-rs";
    rev = "v${version}";
    hash = "sha256-md6e9nRCs6TZarwFD3/GQEoJSIhtdq++rIZTP7Vl0wQ=";
  };

  cargoHash = "sha256-TDP5RC7B7/ldpK22WsmXd6fSl2rHtvG0hP9NYzoEVYo=";

  meta = {
    description = "A simple program that provides DBus interface to control display temperature and brightness under wayland without flickering";
    homepage = "https://github.com/MaxVerevkin/wl-gammarelay-rs";
    license = lib.licenses.gpl3Plus;
    mainProgram = "wl-gammarelay-rs";
    maintainers = with lib.maintainers; [quantenzitrone];
    platforms = lib.platforms.linux;
  };
}
