{
  lib,
  flutter341,
  fetchFromGitHub,
  cmake,
  copyDesktopItems,
  makeDesktopItem,
  libx11,
  libxcursor,
  libxinerama,
  libxi,
  libxext,
  libxrandr,
  libxtst,
  sqlite,
}:

flutter341.buildFlutterApplication (finalAttrs: {
  pname = "windsend";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "doraemonkeys";
    repo = "WindSend";
    tag = "v${finalAttrs.version}";
    hash = "sha256-r3D6Uj8buMceqXov6An+OxgOTcNFrX5PwxhphtbeUv0=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes = lib.importJSON ./git-hashes.json;

  sourceRoot = "${finalAttrs.src.name}/flutter/wind_send";

  nativeBuildInputs = [
    cmake
    copyDesktopItems
  ];

  buildInputs = [
    libx11
    libxcursor
    libxrandr
    libxinerama
    libxi
    libxext
    libxtst
    sqlite
  ];

  dontUseCmakeConfigure = true;

  env.NIX_CFLAGS_COMPILE = "-Wno-error=unused-result";

  desktopItems = [
    (makeDesktopItem {
      name = "windsend";
      exec = "WindSend";
      icon = "windsend";
      desktopName = "WindSend";
    })
  ];

  postInstall = ''
    install -Dm644 ../../app_icon/web/icon-512.png $out/share/icons/hicolor/512x512/apps/windsend.png
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
})
