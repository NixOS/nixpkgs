{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gettext,
  makeWrapper,
  bzip2,
  curl,
  libjpeg,
  libxml2,
  xz,
  lua,
  ode,
  libGL,
  libGLU,
  libpng,
  pkg-config,
  SDL2,
  SDL2_mixer,
  SDL2_net,
  SDL2_ttf,
  sqlite,
  libxdg_basedir,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "xmoto";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-n58GB5HA50ybSq0ssvJMq+p3I3JThHUGLZ5sHy/245M=";
  };

  nativeBuildInputs = [
    cmake
    gettext
    makeWrapper
  ];

  buildInputs = [
    bzip2
    curl
    libjpeg
    libxml2
    xz
    lua
    ode
    libGL
    libGLU
    libpng
    SDL2
    SDL2_mixer
    SDL2_net
    SDL2_ttf
    sqlite
    libxdg_basedir
    zlib
  ];

  # Should normally come from SDL2_ttf pkg-config, but xmoto does not
  # use it and uses include directories directly. Let's re-inject the
  # path here.
  env.NIX_CFLAGS_COMPILE = "-I${lib.getDev SDL2}/include/SDL2";

  preFixup = ''
    wrapProgram "$out/bin/xmoto" \
      --prefix XDG_DATA_DIRS : "$out/share/"
  '';

  meta = with lib; {
    description = "Challenging 2D motocross platform game, where physics play an important role";
    mainProgram = "xmoto";
    longDescription = ''
      X-Moto is a challenging 2D motocross platform game, where physics plays an all important role in the gameplay.
      You need to control your bike to its limits, if you want to have a chance to finish the most difficult challenges.
    '';
    homepage = "https://xmoto.tuxfamily.org";
    maintainers = with maintainers; [
      raskin
      pSub
    ];
    platforms = platforms.all;
    license = licenses.gpl2Plus;
  };
}
