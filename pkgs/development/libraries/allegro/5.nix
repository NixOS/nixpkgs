{
  lib,
  alsa-lib,
  cmake,
  enet,
  fetchFromGitHub,
  fetchpatch2,
  fixDarwinDylibNames,
  flac,
  freetype,
  gitUpdater,
  gtk3,
  libGL,
  libGLU,
  libjpeg,
  libpng,
  libpthread-stubs,
  libpulseaudio,
  libtheora,
  libvorbis,
  libwebp,
  libx11,
  libxcursor,
  libxdmcp,
  libxext,
  libxfixes,
  libxi,
  libxpm,
  libxt,
  libxxf86dga,
  libxxf86misc,
  libxxf86vm,
  openal,
  physfs,
  pkg-config,
  stdenv,
  texinfo,
  xorgproto,
  zlib,
  # https://github.com/liballeg/allegro5/blob/master/README_sdl.txt
  useSDL ? false,
  sdl2-compat ? null,
}:

assert useSDL -> sdl2-compat != null;

stdenv.mkDerivation rec {
  pname = "allegro";
  version = "5.2.11.3";

  src = fetchFromGitHub {
    owner = "liballeg";
    repo = "allegro5";
    rev = version;
    hash = "sha256-Nyab9ytqMZT9no2MT0vDe9tDVxXc6dwScHZ1uMVh+nE=";
  };

  patches = [ ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    fixDarwinDylibNames
  ];

  buildInputs = [
    enet
    flac
    freetype
    gtk3
    libGL
    libGLU
    libjpeg
    libpng
    libtheora
    libvorbis
    libwebp
    openal
    physfs
    texinfo
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    libpthread-stubs
    libpulseaudio
    libx11
    libxcursor
    libxdmcp
    libxext
    libxfixes
    libxi
    libxpm
    libxt
    libxxf86dga
    libxxf86misc
    libxxf86vm
    xorgproto
  ]
  ++ lib.optionals useSDL [
    sdl2-compat
  ];

  postPatch = ''
    sed -e 's@/XInput2.h@/XI2.h@g' -i CMakeLists.txt "src/"*.c
    sed -e 's@Kernel/IOKit/hidsystem/IOHIDUsageTables.h@IOKit/hid/IOHIDUsageTables.h@g' -i include/allegro5/platform/alosx.h
    sed -e 's@OpenAL/@AL/@g' -i addons/audio/openal.c
  '';

  cmakeFlags = [
    "-DCMAKE_SKIP_RPATH=ON"
  ]
  ++ lib.optionals useSDL [
    "ALLEGRO_SDL=ON"
  ];

  outputs = [
    "out"
    "dev"
  ];

  strictDeps = true;

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Game programming library";
    homepage = "https://liballeg.org/";
    license = lib.licenses.zlib;
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
