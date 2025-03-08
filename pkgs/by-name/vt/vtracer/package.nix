{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "vtracer";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "visioncortex";
    repo = "vtracer";
    rev = version;
    hash = "sha256-n5AUc4C0eUfeVe3zTo0ZC/KWMS1/uW/+3Uoz8Q2qQI0=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  meta = {
    description = "Raster to Vector Graphics Converter";
    homepage = "https://github.com/visioncortex/vtracer";
    changelog = "https://github.com/visioncortex/vtracer/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sandptel ];
    mainProgram = "vtracer";
  };
}
