{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libGL,
  libpng,
  libtiff,
  libjpeg,
  libX11,
  SDL2,
  gdal,
  octave,
  rustPlatform,
  cargo,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "vpv";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "kidanger";
    repo = "vpv";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-eyfRMoocKEt0VezDRm5Tq7CjpEyfrcEb6WcUSO5M1Og=";
  };

  cargoRoot = "src/fuzzy-finder";
  cargoDeps = rustPlatform.fetchCargoVendor {
    src = finalAttrs.src;
    sourceRoot = "${finalAttrs.src.name}/src/fuzzy-finder";
    hash = "sha256-4XxhKzrfTulAnLvlzRCrxSxuR+Nl/ANqcUem0YqCQ0Y=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    rustPlatform.cargoSetupHook
    cargo
  ];

  buildInputs = [
    libGL
    libpng
    libtiff
    libjpeg
    libX11
    SDL2
    gdal
    octave
  ];

  cmakeFlags = [
    "-DUSE_GDAL=ON"
    "-DUSE_OCTAVE=ON"
    "-DVPV_VERSION=v${finalAttrs.version}"
    "-DBUILD_TESTING=ON"
  ];

  meta = {
    homepage = "https://github.com/kidanger/vpv";
    description = "Image viewer for image processing experts";
    maintainers = [ lib.maintainers.kidanger ];
    license = lib.licenses.gpl3;
    broken = stdenv.hostPlatform.isDarwin; # the CMake expects the SDL2::SDL2main target for darwin
    mainProgram = "vpv";
  };
})
