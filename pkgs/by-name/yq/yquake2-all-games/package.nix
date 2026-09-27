{
  lib,
  stdenv,
  fetchFromGitHub,
  buildEnv,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
  yquake2,
}:

let
  games = [
    {
      id = "ctf";
      title = "ctf";
      version = "1.07";
      description = "'Capture The Flag' for Yamagi Quake II";
      hash = "sha256-NtItZ5iG42Tdk+Njrt/Pv7kj4KpK/qUzVdAbvCXkK0U=";
    }
    {
      id = "rogue";
      title = "ground-zero";
      version = "2.07";
      description = "'Ground Zero' for Yamagi Quake II";
      hash = "sha256-YTHnJbOTSvy5ZDF2WSFsdQwSHI9UDDcpiPr25t4mWdQ=";
    }
    {
      id = "xatrix";
      title = "the-reckoning";
      version = "2.08";
      description = "'The Reckoning' for Yamagi Quake II";
      hash = "sha256-WddiIUS6fJYCece3TUe0vjcCQyZpEAhTFp5ahMNz6fI=";
    }
  ];

  gameDrvs = map (
    game:
    stdenv.mkDerivation rec {
      inherit (game)
        id
        version
        description
        title
        hash
        ;
      pname = "yquake2-${title}";

      src = fetchFromGitHub {
        inherit hash;
        owner = "yquake2";
        repo = id;
        tag = "${lib.toUpper id}_${builtins.replaceStrings [ "." ] [ "_" ] version}";
      };

      env =
        # Uses `false` and `true` as enum constants, which are keywords in C23 (GCC 15 default)
        lib.optionalAttrs stdenv.cc.isGNU {
          NIX_CFLAGS_COMPILE = "-std=gnu17";
        };

      installPhase = ''
        runHook preInstall
        mkdir -p $out/lib/yquake2/${id}
        cp release/* $out/lib/yquake2/${id}
        runHook postInstall
      '';

      meta = {
        inherit description;
        homepage = "https://www.yamagi.org/quake2/";
        license = lib.licenses.unfree;
        platforms = lib.platforms.unix;
        maintainers = with lib.maintainers; [ tadfisher ];
      };
    }
  ) games;

  env = buildEnv {
    name = "yquake2-all-games-env";
    paths = [
      yquake2
    ]
    ++ gameDrvs;
  };

in
stdenv.mkDerivation {
  pname = "yquake2-all-games";
  version = lib.getVersion yquake2;

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
  ''
  + lib.concatMapStringsSep "\n" (game: ''
    makeWrapper ${env}/bin/yquake2 $out/bin/yquake2-${game.title} \
      --add-flags "+set game ${game.id}"
    makeWrapper ${env}/bin/yq2ded $out/bin/yq2ded-${game.title} \
      --add-flags "+set game ${game.id}"
  '') games
  + ''
    install -Dm644 ${yquake2}/share/icons/hicolor/512x512/apps/yamagi-quake2.png $out/share/icons/hicolor/512x512/apps/yamagi-quake2.png;
    runHook postInstall
  '';

  desktopItems = map (
    game:
    makeDesktopItem {
      name = game.id;
      exec = game.title;
      icon = "yamagi-quake2";
      desktopName = game.id;
      comment = game.description;
      categories = [
        "Game"
        "Shooter"
      ];
    }
  ) games;

  meta = {
    description = "Yamagi Quake II with all add-on games";
  };
}
