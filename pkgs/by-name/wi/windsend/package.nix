{
  lib,
  fetchFromGitHub,
  flutter329,
  copyDesktopItems,
  makeDesktopItem,
}:

flutter329.buildFlutterApplication rec {
  pname = "windsend";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "doraemonkeys";
    repo = "WindSend";
    tag = "v${version}";
    hash = "sha256-mE2pygb4o9gRUdgX/eVsr6WtZxIadxADg+3dpQgP0Ic=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes = {
    open_filex = "sha256-dKLOmk+C9Rzw0wq18I5hkR2T4VcdmT4coimmgF+GzV8=";
    media_scanner = "sha256-vlHsSmw0/bVDSwB/jwdj/flfcizDjYKHOItOb/jWQGM=";
  };

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
    maintainers = with lib.maintainers; [ emaryn ];
    platforms = lib.platforms.linux;
  };
}
