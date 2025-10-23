{
  lib,
  stdenv,
  fetchurl,
  copyDesktopItems,
  makeDesktopItem,
  makeWrapper,
  premake4,
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

  prePatch = ''
    # http://forums.te4.org/viewtopic.php?f=42&t=49478&view=next#p234354
    substituteInPlace src/tgl.h \
      --replace-fail "#include <GL/glext.h>" ""
  '';

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
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

  desktopItems = [
    (makeDesktopItem {
      desktopName = "Tales of Maj'Eyal";
      name = "tome4";
      exec = "tome4";
      icon = "te4-icon";
      comment = "An open-source, single-player, role-playing roguelike game set in the world of Eyal.";
      type = "Application";
      categories = [
        "Game"
        "RolePlaying"
      ];
      genericName = "2D roguelike RPG";
    })
  ];

  # The wrapper needs to cd into the correct directory as tome4's detection of
  # the game asset root directory is faulty.

  installPhase = ''
    runHook preInstall

    dir=$out/share/tome4

    install -Dm755 t-engine $dir/t-engine
    cp -r bootstrap game $dir
    makeWrapper $dir/t-engine $out/bin/tome4 \
      --chdir "$dir"

    install -Dm644 game/engines/default/data/gfx/te4-icon.png -t $out/share/icons/hicolor/64x64

    install -Dm644 -t $out/share/doc/tome4 CONTRIBUTING COPYING COPYING-MEDIA CREDITS

    runHook postInstall
  '';

  meta = {
    description = "Tales of Maj'eyal (rogue-like game)";
    mainProgram = "tome4";
    homepage = "https://te4.org/";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ peterhoeg ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
})
