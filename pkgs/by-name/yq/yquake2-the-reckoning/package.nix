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
  game = {
    id = "xatrix";
    title = "the-reckoning";
    version = "2.08";
    description = "'The Reckoning' for Yamagi Quake II";
    hash = "sha256-WddiIUS6fJYCece3TUe0vjcCQyZpEAhTFp5ahMNz6fI=";
  };

  gameDrv = stdenv.mkDerivation rec {
    inherit (game)
      id
      version
      description
      title
      ;
    pname = "yquake2-${title}";

    src = fetchFromGitHub {
      inherit (game) hash;
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
  };

  env = buildEnv {
    name = "yquake2-the-reckoning-env";
    paths = [
      yquake2
      gameDrv
    ];
  };

in
stdenv.mkDerivation {
  pname = "yquake2-the-reckoning";
  version = lib.getVersion yquake2;

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    makeWrapper ${env}/bin/yquake2 $out/bin/yquake2-${game.title} \
      --add-flags "+set game ${game.id}"
    makeWrapper ${env}/bin/yq2ded $out/bin/yq2ded-${game.title} \
      --add-flags "+set game ${game.id}"
    install -Dm644 ${yquake2}/share/icons/hicolor/512x512/apps/yamagi-quake2.png $out/share/icons/hicolor/512x512/apps/yamagi-quake2.png;
    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = game.id;
      exec = game.title;
      icon = "yamagi-quake2";
      desktopName = game.id;
      comment = game.description;
      categories = [
        "Game"
        "Shooter"
      ];
    })
  ];

  meta = {
    inherit (game) description;
  };
}
