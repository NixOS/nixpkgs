{
  lib,
  appimageTools,
  fetchurl,
}:
let
  pname = "zoho-mail-desktop";
  version = "1.7.1";

  src = fetchurl {
    url = "https://downloads.zohocdn.com/zmail-desktop/linux/zoho-mail-desktop-lite-x64-v${version}.AppImage";
    hash = "sha256-KLDJl91vfTdDtUQ5maDuCBU1HJQf4V0VEnplAc4ytZM=";
  };

  extracted = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    mkdir -p $out/share/applications
    cp -r ${extracted}/usr/share/icons $out/share/
    cp ${extracted}/zoho-mail-desktop.desktop $out/share/applications/
    substituteInPlace $out/share/applications/zoho-mail-desktop.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=zoho-mail-desktop'
  '';

  meta = {
    description = "Zoho Mail Desktop Lite client";
    homepage = "https://www.zoho.com/mail/desktop/";
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.juliuskreutz ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "zoho-mail-desktop";
  };
}
