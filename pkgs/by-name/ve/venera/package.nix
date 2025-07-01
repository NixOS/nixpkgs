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
  version = "1.4.5";

  src = fetchFromGitHub {
    owner = "venera-app";
    repo = "venera";
    tag = "v${version}";
    hash = "sha256-yg7VwR1IGswyqkyuvTZnVVLI4YKnfcea+VemWLOUXto=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes =
    let
      flutter_inappwebview-hash = "sha256-Vh5bZP/tkSAlstbT3souy/iLmpw3CENrA/rCUOcJb2o=";
    in
    {
      desktop_webview_window = "sha256-c2f1CjfZJ8M9SJz65WQVG+0uuKaFMjQFFAGSNH9osjg=";
      flutter_qjs = "sha256-Mp9swQ4JEIyIEBQGlR7i+37Jp2sFGwL0uGrSTwE/n88=";
      flutter_7zip = "sha256-KHDq4XG3l+dq1NPW84wOK5kKbXJ8qCK8voGeTnX/Krw=";
      lodepng_flutter = "sha256-fOOhjoo3dzNNZI04Ie7GHLTfVlD5X+5IONpg8+RlmsE=";
      photo_view = "sha256-zRc/WCbVybWkF52KDZZXgvKA8bbXASI7Yj2RFzLhXUk=";
      scrollable_positioned_list = "sha256-6XmBlNxE7DEqY2LsEFtVrshn2Xt55XnmaiTq+tiPInA=";
      webdav_client = "sha256-euNF7HdDtZ68BqSEq9BvO10BK09MxX2wWGoElFS0yeE=";
      flutter_saf = "sha256-zmRZ82aJPYX/N/lOUcOoT8UAHEDoUk0FTFSqB4gKR+U=";
      rhttp = "sha256-6AH7A+CJg60Vk0ph3cJwj29GkmJEezI/VuZvRqqmOYs=";
      flutter_inappwebview = flutter_inappwebview-hash;
      flutter_inappwebview_android = flutter_inappwebview-hash;
      flutter_inappwebview_ios = flutter_inappwebview-hash;
      flutter_inappwebview_macos = flutter_inappwebview-hash;
      flutter_inappwebview_web = flutter_inappwebview-hash;
      flutter_inappwebview_windows = flutter_inappwebview-hash;
      flutter_inappwebview_platform_interface = flutter_inappwebview-hash;
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
