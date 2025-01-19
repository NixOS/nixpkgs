{
  lib,
  fetchFromGitHub,
  flutter324,
  copyDesktopItems,
  makeDesktopItem,
}:

flutter324.buildFlutterApplication rec {
  pname = "windsend";
  version = "1.4.9";

  src = fetchFromGitHub {
    owner = "doraemonkeys";
    repo = "WindSend";
    tag = "v${version}";
    hash = "sha256-jmFhYCUE37yH+TTHq8Q0bO1Lp/p07PnSJDMAOGbhwOM=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes = {
    aes_crypt_null_safe = "sha256-1g5QD5s2uxw0zi1mboEByLJwd7193xRstJ5Pm5JgRsU=";
    media_scanner = "sha256-kAn4Adv+ub4DBovvU44Td4KnfoQJDNVp/J8tdwa5z+w=";
  };

  sourceRoot = "${src.name}/flutter/wind_send";

  nativeBuildInputs = [
    copyDesktopItems
  ];

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

  meta = {
    description = "Quickly and securely sync clipboard, transfer files and directories between devices";
    homepage = "https://github.com/doraemonkeys/WindSend";
    mainProgram = "WindSend";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ aucub ];
    platforms = lib.platforms.linux;
  };
}
