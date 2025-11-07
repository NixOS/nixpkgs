{
  lib,
  flutter329,
  makeDesktopItem,
  copyDesktopItems,
  fetchFromGitHub,
}:

flutter329.buildFlutterApplication rec {
  pname = "tts-mod-vault";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "markomijic";
    repo = "TTS-Mod-Vault";
    tag = "v${version}";
    hash = "sha256-BTs+4QeyVJeg415uiNXww8twQwUInHfB8voWJjeVs20=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  desktopItems = [
    (makeDesktopItem {
      name = "tts_mod_vault";
      exec = "tts_mod_vault";
      icon = "tts_mod_vault";
      comment = "Tabletop Simulator Mod Vault";
      desktopName = "TTS Mod Vault";
      categories = [ "Utility" ];
    })
  ];

  nativeBuildInputs = [ copyDesktopItems ];

  postInstall = ''
    install -m 444 -D assets/icon/tts_mod_vault_icon.png $out/share/icons/hicolor/1024x1024/apps/tts_mod_vault.png
  '';

  meta = {
    description = "Download and backup assets for your Tabletop Simulator mods";
    homepage = "https://github.com/markomijic/TTS-Mod-Vault";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ esch ];
    mainProgram = "tts_mod_vault";
    platforms = lib.platforms.linux;
  };
}
