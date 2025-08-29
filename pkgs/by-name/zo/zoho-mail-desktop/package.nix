{
  lib,
  appimageTools,
  fetchurl,
}:
appimageTools.wrapType2 rec {
  pname = "zoho-mail-desktop";
  version = "1.6.5";

  src = fetchurl {
    url = "https://downloads.zohocdn.com/zmail-desktop/linux/${pname}-lite-x64-v${version}.AppImage";
    hash = "sha256-TiPf5tQnVjPpzteSxIa4RLEyYBx6ohnnxPTAG0JjnrM=";
  };

  extracted = appimageTools.extract { inherit pname version src; };

  extraInstallCommands = ''
    install -m 444 -D ${extracted}/${pname}.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=${pname}'
    cp -r ${extracted}/usr/share/icons $out/share
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
