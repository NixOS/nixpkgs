{
  lib,
  stdenv,
  autoreconfHook,
  fetchFromGitHub,
  pkg-config,
  lua,
  fpc,
  pcre,
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
    pcre
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
  version = "2024.10.0";

  src = fetchFromGitHub {
    owner = "UltraStar-Deluxe";
    repo = "USDX";
    rev = "v${version}";
    hash = "sha256-X5LixPRAI7A8Ns3D2A24T05w0iHag1EJVqt0aW1ZBps=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];
  buildInputs = [
    fpc
    libpng
  ] ++ sharedLibs;

  postPatch = ''
    substituteInPlace src/config.inc.in \
      --subst-var-by libpcre_LIBNAME libpcre.so.1
  '';

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
    maintainers = with maintainers; [ Profpatsch ];
    platforms = platforms.linux;
  };
}
