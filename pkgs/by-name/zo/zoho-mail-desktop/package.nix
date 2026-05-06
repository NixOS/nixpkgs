{
  lib,
  appimageTools,
  fetchurl,
}:

let
  pname = "zoho-mail-desktop";
  version = "1.7.4";

  src = fetchurl {
    url = "https://downloads.zohocdn.com/zmail-desktop/linux/zoho-mail-desktop-lite-x64-v${version}.AppImage";
    hash = "sha256-uGz2sksBMbw/17ia/RU/9kJhf4EMeSFrMX27D9XplrI=";
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

    for size in 16 32 48 64 128 256 512 1024; do
      install -Dm444 ${appimageContents}/usr/share/icons/hicolor/''${size}x''${size}/apps/zoho-mail-desktop.png \
        $out/share/icons/hicolor/''${size}x''${size}/apps/zoho-mail-desktop.png
    done

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
