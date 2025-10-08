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
  version = "2025.10.0";

  src = fetchFromGitHub {
    owner = "UltraStar-Deluxe";
    repo = "USDX";
    rev = "v${version}";
    hash = "sha256-rJhPVq6rheAtPHkDi8zPb1OGKHP56rl7jG9sKVDEqUw=";
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
  };
}
