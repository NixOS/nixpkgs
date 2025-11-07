{
  lib,
  flutter332,
  fetchFromGitHub,
  copyDesktopItems,
  makeDesktopItem,
}:

flutter332.buildFlutterApplication rec {
  pname = "windsend";
  version = "1.5.5";

  src = fetchFromGitHub {
    owner = "doraemonkeys";
    repo = "WindSend";
    tag = "v${version}";
    hash = "sha256-u82VmMuc7+tbc1Qgs5lbyFlNTauJm6E9KFXPHBdTryA=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes = lib.importJSON ./git-hashes.json;

  sourceRoot = "${src.name}/flutter/wind_send";

  nativeBuildInputs = [ copyDesktopItems ];

  desktopItems = [
    (makeDesktopItem {
      name = "windsend";
      exec = "WindSend";
      icon = "windsend";
      desktopName = "WindSend";
    })
  ];

  postInstall = ''
    install -Dm644 ../../app_icon/web/icon-512.png $out/share/pixmaps/windsend.png
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Quickly and securely sync clipboard, transfer files and directories between devices";
    homepage = "https://github.com/doraemonkeys/WindSend";
    mainProgram = "WindSend";
    license = with lib.licenses; [ mit ];
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
