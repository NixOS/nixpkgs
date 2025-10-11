{
  lib,
  appimageTools,
  fetchurl,
}:
appimageTools.wrapType2 rec {
  pname = "zoho-mail-desktop";
  version = "1.6.7";

  src = fetchurl {
    url = "https://downloads.zohocdn.com/zmail-desktop/linux/${pname}-lite-x64-v${version}.AppImage";
    hash = "sha256-BesPuEMNpHZffAt+96CcEGH6Bj/OpIOH5PyviGYfW2w=";
  };

  extracted = appimageTools.extract { inherit pname version src; };

  extraInstallCommands = ''
    mkdir -p $out/share/applications
    mkdir -p $out/share/lib/${pname}

    cp -r ${extracted}/usr/* $out/
    cp -r ${extracted}/{locales,resources} $out/share/lib/${pname}/

    cp ${extracted}/${pname}.desktop $out/share/applications/
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=${pname}'
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
