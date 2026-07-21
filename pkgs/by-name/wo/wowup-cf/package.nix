{
  lib,
  appimageTools,
  fetchurl,
}:

let
  version = "2.22.0";
  pname = "wowup-cf";

  src = fetchurl {
    url = "https://github.com/WowUp/WowUp.CF/releases/download/v${version}/WowUp-CF-${version}.AppImage";
    hash = "sha256-X5gDnj4YBZRBwJEeb8sVMNoGmWUI9iVdWOmsA20bWig=";
  };

  appimageContents = appimageTools.extractType1 { inherit pname version src; };
in
appimageTools.wrapType1 {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = {
    description = "World of Warcraft addon updater with CurseForge support";
    longDescription = ''
      WowUp is the community centered World of Warcraft addon updater. We attempt to bring the addon community together in an easy to use updater application. We have an ever growing list of supported features.
    '';
    mainProgram = "wowup-cf";
    homepage = "https://wowup.io/";
    downloadPage = "https://github.com/WowUp/WowUp.CF/releases";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ pbek ];
    platforms = [ "x86_64-linux" ];
  };
}
