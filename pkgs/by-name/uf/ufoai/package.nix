{
  lib,
  stdenv,
  copyDesktopItems,
  fetchFromGitHub,
  fetchurl,
  installShellFiles,
  makeDesktopItem,
  makeWrapper,
  pkg-config,
  libtheora,
  xvidcore,
  libGLU,
  libGL,
  SDL2,
  SDL2_ttf,
  SDL2_mixer,
  curl,
  libjpeg,
  libogg,
  libpng,
  libvorbis,
  minixml,
  gettext,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ufoai";
  version = "2.5-unstable-2020-12-24";

  # unstable for fixes needed by current compilers
  src = fetchFromGitHub {
    owner = "ufoaiorg";
    repo = "ufoai";
    rev = "59e97870caaab03960e4ea7d16b2de3c18898c94";
    hash = "sha256-G2icAJs5uldiuIOOuGtzl03bYqexTYi62XCY6D+IT8M=";
  };

  srcData = fetchurl {
    urls = [
      # Gentoo mirrors the same file, SourceForge only serves it slowly
      "mirror://gentoo/distfiles/72/ufoai-2.5-data.tar"
      "mirror://sourceforge/ufoai/ufoai-2.5-data.tar"
    ];
    hash = "sha256-XnBqQkr/ai6jCkx5gSnWME6Jc4fq34CFKBKbUSt9zbA=";
  };

  # switching the display mode for fullscreen breaks the mouse on macOS, so
  # use the desktop's mode and render at its size instead
  patches = lib.optionals stdenv.hostPlatform.isDarwin [ ./darwin-fullscreen-desktop.patch ];

  env = {
    # to avoid occasional runtime error in finding libgcc_s.so.1
    NIX_CFLAGS_LINK = lib.optionalString stdenv.hostPlatform.isLinux "-lgcc_s";
  };

  preConfigure = ''tar xvf "${finalAttrs.srcData}"'';

  configureFlags = [
    "--enable-release"
  ]
  ++ lib.optionals stdenv.hostPlatform.isx86 [ "--enable-sse" ]
  ++ [
    # upstream's unit tests and memory debugging tool, never run here
    "--disable-testall"
    "--disable-memory"
  ];

  nativeBuildInputs = [
    copyDesktopItems
    installShellFiles
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ makeWrapper ];

  buildInputs = [
    libtheora
    xvidcore
    libGLU
    libGL
    SDL2
    SDL2_ttf
    SDL2_mixer
    curl
    libjpeg
    libogg
    libpng
    libvorbis
    minixml
    gettext
    zlib
  ];

  enableParallelBuilding = true;

  # the map editor needs GTK 2 and is not built, but its launcher is installed
  postInstall = ''
    rm $out/bin/uforadiant

    install -Dm644 src/ports/linux/ufo.png $out/share/icons/hicolor/32x32/apps/ufoai.png
    install -Dm644 src/ports/linux/ufoded.png $out/share/icons/hicolor/32x32/apps/ufoded.png
    installManPage debian/ufo.6 debian/ufoded.6 debian/ufo2map.6
  ''
  # upstream's macOS bundle layout: the game changes into the bundle at
  # startup and expects its data in UFOAI.app/base
  + lib.optionalString stdenv.hostPlatform.isDarwin (
    let
      # not included in GitHub's source archive
      bundleFile =
        path: hash:
        fetchurl {
          url = "https://raw.githubusercontent.com/ufoaiorg/ufoai/${finalAttrs.src.rev}/contrib/installer/mac/UFOAI.app/Contents/${path}";
          inherit hash;
        };
    in
    ''
      app=$out/Applications/UFOAI.app
      mkdir -p $app/Contents/{MacOS,Resources}
      mv $out/games/ufo/{ufo,ufoded,ufo2map,ufomodel,ufoslicer} $app/Contents/MacOS/
      mv $out/games/ufo/base $app/base
      rmdir $out/games/ufo $out/games

      substitute ${bundleFile "Info.plist.in" "sha256-oRjLMbXUqEXP/1w3LdogdGJT7/73LE4kpLcPZFqoglo="} \
        $app/Contents/Info.plist \
        --replace-fail @UFOAI_VERSION@ ${lib.versions.majorMinor finalAttrs.version}
      install -Dm644 ${bundleFile "Resources/ufo.icns" "sha256-gnndStojWNflOyc7uDKVlY9Kb0pkBz36y+un39Yy4ac="} \
        $app/Contents/Resources/ufo.icns

      for prog in ufo ufoded; do
        rm $out/bin/$prog
        makeWrapper $app/Contents/MacOS/$prog $out/bin/$prog
      done
    ''
  );

  desktopItems = [
    (makeDesktopItem {
      name = "ufoai";
      desktopName = "UFO: Alien Invasion";
      comment = "Turn-based tactical combat against hostile alien forces";
      exec = "ufo";
      icon = "ufoai";
      categories = [
        "Game"
        "StrategyGame"
      ];
    })
    (makeDesktopItem {
      name = "ufoded";
      desktopName = "UFO: AI Dedicated Server";
      comment = "Turn-based tactical combat against hostile alien forces (server)";
      exec = "ufoded";
      icon = "ufoded";
      terminal = true;
      categories = [
        "Game"
        "StrategyGame"
      ];
    })
  ];

  meta = {
    homepage = "http://ufoai.org";
    description = "Squad-based tactical strategy game in the tradition of X-Com";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ iedame ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    hydraPlatforms = [ ];
  };
})
