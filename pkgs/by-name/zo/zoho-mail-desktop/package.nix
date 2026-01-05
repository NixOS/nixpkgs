{
  lib,
  appimageTools,
  fetchurl,
}:

let
  pname = "zoho-mail-desktop";
  version = "1.7.2";

  src = fetchurl {
    url = "https://downloads.zohocdn.com/zmail-desktop/linux/zoho-mail-desktop-lite-x64-v${version}.AppImage";
    hash = "sha256-hoWOujwfm5/DS/0Kh69gqIKmc1dnVSOYJP/zypvcy8I=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
  };

in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/zoho-mail-desktop.desktop \
      $out/share/applications/zoho-mail-desktop.desktop

    install -Dm444 ${appimageContents}/usr/share/icons/hicolor/1024x1024/apps/zoho-mail-desktop.png \
      $out/share/icons/hicolor/1024x1024/apps/zoho-mail-desktop.png

    substituteInPlace $out/share/applications/zoho-mail-desktop.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = {
    description = "Desktop client for Zoho Mail";
    homepage = "https://www.zoho.com/mail/desktop/";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ rohi-devs ];
    mainProgram = "zoho-mail-desktop";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
