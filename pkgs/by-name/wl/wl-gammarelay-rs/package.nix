{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "wl-gammarelay-rs";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "MaxVerevkin";
    repo = "wl-gammarelay-rs";
    tag = "v${version}";
    hash = "sha256-WdY90CUtphtUUFAh+daSQGmlWTn28Qc79A5yHTV3IOY=";
  };

  cargoHash = "sha256-B7ot2qcs1rXcrBveXRdZlbiKCRvNAg+OfqYuZv6m8PM=";

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
