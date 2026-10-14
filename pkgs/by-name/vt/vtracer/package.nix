{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "vtracer";
  version = "0.6.15";

  src = fetchFromGitHub {
    owner = "visioncortex";
    repo = "vtracer";
    tag = finalAttrs.version;
    hash = "sha256-A575QnbituecxIX0mm7bOMC+V8jeWB4j3A2iWgDKBts=";
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
    changelog = "https://github.com/visioncortex/vtracer/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sandptel ];
    mainProgram = "vtracer";
  };
})
