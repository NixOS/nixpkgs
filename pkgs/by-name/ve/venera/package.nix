{
  lib,
  flutter341,
  fetchFromGitHub,
  webkitgtk_4_1,
  copyDesktopItems,
  makeDesktopItem,
  runCommand,
  yq-go,
  _experimental-update-script-combinators,
  nix-update-script,
  dart,
}:

flutter341.buildFlutterApplication (finalAttrs: {
  pname = "venera";
  version = "1.6.3";

  src = fetchFromGitHub {
    owner = "venera-app";
    repo = "venera";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UgQej91SsqyZzJaN3kQDHqJI3686W451wBTeTACXrV8=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes = lib.importJSON ./git-hashes.json;

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
    install -D --mode=0644 debian/gui/venera.png $out/share/icons/venera.png
  '';

  extraWrapProgramArgs = ''
    --prefix LD_LIBRARY_PATH : $out/app/venera/lib
  '';

  passthru = {
    pubspecSource =
      runCommand "pubspec.lock.json"
        {
          inherit (finalAttrs) src;
          nativeBuildInputs = [ yq-go ];
        }
        ''
          yq eval --output-format=json --prettyPrint $src/pubspec.lock > "$out"
        '';
    updateScript = _experimental-update-script-combinators.sequence [
      (nix-update-script { })
      (
        (_experimental-update-script-combinators.copyAttrOutputToFile "venera.pubspecSource" ./pubspec.lock.json)
        // {
          supportedFeatures = [ ];
        }
      )
      {
        command = [
          dart.fetchGitHashesScript
          "--input"
          ./pubspec.lock.json
          "--output"
          ./git-hashes.json
        ];
        supportedFeatures = [ ];
      }
    ];
  };

  meta = {
    description = "Comic reader that support reading local and network comics";
    homepage = "https://github.com/venera-app/venera";
    mainProgram = "venera";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
