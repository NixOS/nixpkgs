{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "vtracer";
  version = "0.6.5";

  src = fetchFromGitHub {
    owner = "visioncortex";
    repo = "vtracer";
    rev = version;
    hash = "sha256-gU2LxUbgy2KgMCu7nyjfGkmBwnA9mjX4mUT9M9k1a4I=";
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
