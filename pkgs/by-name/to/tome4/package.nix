{
  lib,
  stdenv,
  fetchurl,
  fetchpatch2,
  copyDesktopItems,
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
  libx11,
  xorgproto,
}:

let
  sdlInputs = [
    SDL2
    SDL2_ttf
    SDL2_image
  ];
in

stdenv.mkDerivation (finalAttrs: {
  pname = "tome4";
  version = "1.7.6";

  src = fetchurl {
    url = "https://te4.org/dl/t-engine/t-engine4-src-${finalAttrs.version}.tar.bz2";
    hash = "sha256-mJ3qAIA/jNyt4CT0ZH1IC7GsDUN8JUKSwHVJwnKkaAw=";
  };

  prePatch = ''
    # http://forums.te4.org/viewtopic.php?f=42&t=49478&view=next#p234354
    substituteInPlace src/tgl.h \
      --replace-fail "#include <GL/glext.h>" ""
  '';

  patches = [
    # https://forums.te4.org/viewtopic.php?f=69&t=39859&p=168681&hilit=luaopen_shaders#p168681
    (fetchpatch2 {
      url = "https://gist.githubusercontent.com/hasufell/cb3b10f834e891d90f83/raw/cb4adda13868f6b94585575db4f8df70877ae45a/tome4-1.1.3-fix-implicit-declaration.patch";
      hash = "sha256-g47N/bi2/DDKqaEkfTaGp9ItS57QVnObzMDWXqrCjWE=";
    })
    # unistd required for execv
    ./0001-web-missing-include.patch
    # unistd required for read and close
    ./0002-zlib-missing-include.patch
    ./0003-incompatible-pointer-types.patch
    # C23 requires stdbool for an actual proper boolean type instead of `char'
    ./0004-fix-build-with-C23.patch
  ];

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
    premake4
    unzip
  ];

  # tome4 vendors quite a few libraries so someone might want to look
  # into avoiding that...
  buildInputs = [
    libGLU
    openal
    libpng
    libvorbis
    libx11
    xorgproto
  ]
  ++ sdlInputs;

  # disable parallel building as it caused sporadic build failures
  enableParallelBuilding = false;

  env = {
    NIX_CFLAGS_COMPILE =
      lib.concatMapStringsSep " " (i: "-I${lib.getInclude i}/include/SDL2") sdlInputs
      + " "
      + lib.concatMapStringsSep " " (i: "-I${lib.getInclude i}") finalAttrs.buildInputs;

    NIX_CFLAGS_LINK = lib.concatMapStringsSep " " (i: "-L${lib.getLib i}/lib") finalAttrs.buildInputs;
  };

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

    # the release tarball ships the engine as a zip archive
    unzip -p game/engines/te4-${finalAttrs.version}.teae data/gfx/te4-icon.png > te4-icon.png
    install -Dm644 te4-icon.png -t $out/share/icons/hicolor/64x64/apps

    install -Dm644 -t $out/share/doc/tome4 CONTRIBUTING COPYING COPYING-MEDIA CREDITS

    runHook postInstall
  '';

  meta = {
    description = "Tales of Maj'eyal (rogue-like game)";
    mainProgram = "tome4";
    homepage = "https://te4.org/";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      iedame
      peterhoeg
    ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
})
