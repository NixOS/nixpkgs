{
  lib,
  fetchFromGitHub,
  flutter327,
  webkitgtk_4_1,
  copyDesktopItems,
  makeDesktopItem,
  runCommand,
  venera,
  yq,
  _experimental-update-script-combinators,
  gitUpdater,
}:

flutter327.buildFlutterApplication rec {
  pname = "venera";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "venera-app";
    repo = "venera";
    tag = "v${version}";
    hash = "sha256-ac1ZH4/56ZcY59jgOki+RqOjh/tWL0xpAwc+wpxPgqw=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes =
    let
      flutter_inappwebview-hash = "sha256-Vh5bZP/tkSAlstbT3souy/iLmpw3CENrA/rCUOcJb2o=";
    in
    {
      desktop_webview_window = "sha256-15tw3gLN9e886QjBFuYP34KLD1lN8AmQYXVza5Bvs40=";
      flutter_qjs = "sha256-nbXKfiCvG6JT570RNVq3gec+JFw3H7XG4g/QSNkDw18=";
      flutter_7zip = "sha256-KHDq4XG3l+dq1NPW84wOK5kKbXJ8qCK8voGeTnX/Krw=";
      lodepng_flutter = "sha256-bGc9uXD1EQ/19OIZmR7a/YL9w93fNWdQF5S19LSwxZw=";
      photo_view = "sha256-u0EBzWlWCjvcnuzrcc1iIsREzLdFSLy0UxPW2rpeHAw=";
      scrollable_positioned_list = "sha256-6XmBlNxE7DEqY2LsEFtVrshn2Xt55XnmaiTq+tiPInA=";
      webdav_client = "sha256-Dz/4qW+cYGyNtK8S/abFslwQNroidgrHl7oJw3uXIqM=";
      flutter_saf = "sha256-haY4eabTwUUBTpwenK0ILKpLggrtjVQszcmlpirEeTU=";
      flutter_inappwebview = flutter_inappwebview-hash;
      flutter_inappwebview_android = flutter_inappwebview-hash;
      flutter_inappwebview_ios = flutter_inappwebview-hash;
      flutter_inappwebview_macos = flutter_inappwebview-hash;
      flutter_inappwebview_web = flutter_inappwebview-hash;
      flutter_inappwebview_windows = flutter_inappwebview-hash;
      flutter_inappwebview_platform_interface = flutter_inappwebview-hash;
      rhttp = "sha256-8+BN2P4c1Cr8N/t8rnMghBOcUxBNjo2NOs16jyuxWdY=";
    };

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
    install -Dm0644 ./debian/gui/venera.png $out/share/pixmaps/venera.png
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
