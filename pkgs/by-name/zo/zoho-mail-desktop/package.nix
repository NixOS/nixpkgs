{
  lib,
  appimageTools,
  fetchurl,
}:

appimageTools.wrapType2 (finalAttrs: {
  pname = "zoho-mail-desktop";
  version = "1.10.3";
  src = fetchurl {
    url = "https://downloads.zohocdn.com/zmail-desktop/linux/zoho-mail-desktop-lite-x64-v${finalAttrs.version}.AppImage";
    hash = "sha256-aUOEdjSkSgWx3wUZqYFJeZ+h0rToEGeP22iTYD8k6F4=";
  };

  extraInstallCommands = ''
    install -Dm444 ${finalAttrs.contents}/zoho-mail-desktop.desktop \
      $out/share/applications/zoho-mail-desktop.desktop

    for size in 16 32 48 64 128 256 512 1024; do
      install -Dm444 ${finalAttrs.contents}/usr/share/icons/hicolor/''${size}x''${size}/apps/zoho-mail-desktop.png \
        $out/share/icons/hicolor/''${size}x''${size}/apps/zoho-mail-desktop.png
    done

    substituteInPlace $out/share/applications/zoho-mail-desktop.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=${finalAttrs.pname}'
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
})
