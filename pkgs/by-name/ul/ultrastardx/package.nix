{
  lib,
  stdenv,
  autoreconfHook,
  fetchFromGitHub,
  pkg-config,
  lua,
  fpc,
  portaudio,
  freetype,
  libpng,
  SDL2,
  SDL2_image,
  SDL2_gfx,
  SDL2_mixer,
  SDL2_net,
  SDL2_ttf,
  ffmpeg,
  sqlite,
  zlib,
  libX11,
  libGLU,
  libGL,
}:

let
  sharedLibs = [
    portaudio
    freetype
    SDL2
    SDL2_image
    SDL2_gfx
    SDL2_mixer
    SDL2_net
    SDL2_ttf
    sqlite
    lua
    zlib
    libX11
    libGLU
    libGL
    ffmpeg
  ];

in
stdenv.mkDerivation rec {
  pname = "ultrastardx";
<<<<<<< HEAD
  version = "2025.12.1";
=======
  version = "2025.10.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "UltraStar-Deluxe";
    repo = "USDX";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-NwYFsd15nUgEnzQaoZdp7Au1H1QrrpoZX8PmnQ9URVA=";
=======
    hash = "sha256-inPRCIgASg/dh1DQ62uabWx4STNRR0p8CWxisltfLgE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];
  buildInputs = [
    fpc
    libpng
  ]
  ++ sharedLibs;

  preBuild =
    let
      items = lib.concatMapStringsSep " " (x: "-rpath ${lib.getLib x}/lib") sharedLibs;
    in
    ''
      export NIX_LDFLAGS="$NIX_LDFLAGS ${items}"
    '';

  # dlopened libgcc requires the rpath not to be shrinked
  dontPatchELF = true;

<<<<<<< HEAD
  meta = {
    homepage = "https://usdx.eu/";
    description = "Free and open source karaoke game";
    mainProgram = "ultrastardx";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      diogotcorreia
      Profpatsch
    ];
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    homepage = "https://usdx.eu/";
    description = "Free and open source karaoke game";
    mainProgram = "ultrastardx";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [
      diogotcorreia
      Profpatsch
    ];
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
