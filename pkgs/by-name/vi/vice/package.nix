{
  lib,
  stdenv,
  fetchurl,
  bison,
  flex,
  perl,
  curl,
  libpng,
  giflib,
  alsa-lib,
  readline,
  libGLU,
  libGL,
  pkg-config,
  gtk3,
  glew,
  SDL,
  SDL_image,
  dos2unix,
  runtimeShell,
  xa,
  file,
  wrapGAppsHook3,
  xdg-utils,
  libevdev,
  pulseaudio,
}:

stdenv.mkDerivation rec {
  pname = "vice";
  version = "3.9";

  src = fetchurl {
    url = "mirror://sourceforge/vice-emu/vice-${version}.tar.gz";
    sha256 = "sha256-QCArY0VeJrh+zGPrWlIyLG+j9XyrEqzwwifPn02uw3A=";
  };

  nativeBuildInputs = [
    bison
    dos2unix
    file
    flex
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    alsa-lib
    curl
    giflib
    gtk3
    glew
    libGL
    libGLU
    libpng
    perl
    readline
    SDL
    SDL_image
    xa
    xdg-utils
    libevdev
    pulseaudio
  ];
  dontDisableStatic = true;
  configureFlags = [
    "--enable-sdl2ui"
    "--enable-gtk3ui"
    "--enable-desktop-files"
    "--disable-pdf-docs"
    "--with-gif"
  ];

  LIBS = "-lGL";

  preBuild = ''
    sed -i -e 's|#!/usr/bin/env bash|${runtimeShell}/bin/bash|' src/arch/gtk3/novte/box_drawing_generate.sh
  '';

  postInstall = ''
    mkdir -p $out/share/applications
    cp src/arch/gtk3/data/unix/vice-org-*.desktop $out/share/applications
  '';

  meta = {
    description = "Emulators for a variety of 8-bit Commodore computers";
    homepage = "https://vice-emu.sourceforge.io/";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.sander ];
    platforms = lib.platforms.linux;
  };
}
