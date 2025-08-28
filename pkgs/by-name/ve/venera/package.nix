{
  lib,
  flutter332,
  fetchFromGitHub,
  webkitgtk_4_1,
  copyDesktopItems,
  makeDesktopItem,
  runCommand,
  venera,
  yq,
  _experimental-update-script-combinators,
  gitUpdater,
}:

flutter332.buildFlutterApplication rec {
  pname = "venera";
  version = "1.4.6";

  src = fetchFromGitHub {
    owner = "venera-app";
    repo = "venera";
    tag = "v${version}";
    hash = "sha256-WGzgx+QbAurv9yOJjO40R8t4WtSt/iIkkBuBizT94lQ=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes = lib.importJSON ./gitHashes.json;

  nativeBuildInputs = [ copyDesktopItems ];

  buildInputs = [ webkitgtk_4_1 ];

  desktopItems = [
    (makeDesktopItem {
      name = "venera";
      exec = "venera";
      icon = "venera";
      genericName = "Venera";
      desktopName = "Venera";
      categories = [
        "Utility"
      ];
      keywords = [
        "Flutter"
        "comic"
        "images"
      ];
    })
  ];

  postInstall = ''
    install -Dm0644 debian/gui/venera.png $out/share/pixmaps/venera.png
  '';

  extraWrapProgramArgs = ''
    --prefix LD_LIBRARY_PATH : $out/app/venera/lib
  '';

  passthru = {
    pubspecSource =
      runCommand "pubspec.lock.json"
        {
          buildInputs = [ yq ];
          inherit (venera) src;
        }
        ''
          cat $src/pubspec.lock | yq > $out
        '';
    updateScript = _experimental-update-script-combinators.sequence [
      (gitUpdater { rev-prefix = "v"; })
      (_experimental-update-script-combinators.copyAttrOutputToFile "venera.pubspecSource" ./pubspec.lock.json)
      {
        command = [ ./update-gitHashes.py ];
        supportedFeatures = [ "silent" ];
      }
    ];
  };

  meta = {
    description = "Comic reader that support reading local and network comics";
    homepage = "https://github.com/venera-app/venera";
    mainProgram = "venera";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.linux;
  };
}
