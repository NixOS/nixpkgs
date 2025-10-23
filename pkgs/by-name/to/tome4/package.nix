{
  lib,
  stdenv,
  fetchurl,
  makeDesktopItem,
  makeWrapper,
  premake4,
  unzip,
  openal,
  libpng,
  libvorbis,
  libGLU,
  SDL2,
  SDL2_image,
  SDL2_ttf,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tome4";
  version = "1.7.6";

  src = fetchurl {
    url = "https://te4.org/dl/t-engine/t-engine4-src-${finalAttrs.version}.tar.bz2";
    sha256 = "sha256-mJ3qAIA/jNyt4CT0ZH1IC7GsDUN8JUKSwHVJwnKkaAw=";
  };

  desktop = makeDesktopItem {
    desktopName = "tome4";
    name = "Tales of Maj'Eyal";
    exec = "@out@/bin/tome4";
    icon = "tome4";
    comment = "An open-source, single-player, role-playing roguelike game set in the world of Eyal.";
    type = "Application";
    categories = [
      "Game"
      "RolePlaying"
    ];
    genericName = "2D roguelike RPG";
  };

  prePatch = ''
    # http://forums.te4.org/viewtopic.php?f=42&t=49478&view=next#p234354
    sed -i 's|#include <GL/glext.h>||' src/tgl.h
  '';

  nativeBuildInputs = [
    makeWrapper
    unzip
    premake4
  ];

  # tome4 vendors quite a few libraries so someone might want to look
  # into avoiding that...
  buildInputs = [
    libGLU
    openal
    libpng
    libvorbis
    SDL2
    SDL2_ttf
    SDL2_image
  ];

  # disable parallel building as it caused sporadic build failures
  enableParallelBuilding = false;

  env.NIX_CFLAGS_COMPILE = "-I${lib.getInclude SDL2}/include/SDL2 -I${SDL2_image}/include/SDL2 -I${SDL2_ttf}/include/SDL2";

  makeFlags = [ "config=release" ];

  # The wrapper needs to cd into the correct directory as tome4's detection of
  # the game asset root directory is faulty.

  installPhase = ''
    runHook preInstall

    dir=$out/share/tome4

    install -Dm755 t-engine $dir/t-engine
    cp -r bootstrap game $dir
    makeWrapper $dir/t-engine $out/bin/tome4 \
      --chdir "$dir"

    install -Dm755 ${finalAttrs.desktop}/share/applications/tome4.desktop $out/share/applications/tome4.desktop
    substituteInPlace $out/share/applications/tome4.desktop \
      --subst-var out

    unzip -oj -qq game/engines/te4-${finalAttrs.version}.teae data/gfx/te4-icon.png
    install -Dm644 te4-icon.png $out/share/icons/hicolor/64x64/tome4.png

    install -Dm644 -t $out/share/doc/tome4 CONTRIBUTING COPYING COPYING-MEDIA CREDITS

    runHook postInstall
  '';

  meta = with lib; {
    description = "Tales of Maj'eyal (rogue-like game)";
    mainProgram = "tome4";
    homepage = "https://te4.org/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
})
