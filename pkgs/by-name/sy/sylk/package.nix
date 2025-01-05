{
  appimageTools,
  fetchurl,
  lib,
}:

appimageTools.wrapType2 rec {
  pname = "sylk";
  version = "3.0.1";

  src = fetchurl {
    url = "http://download.ag-projects.com/Sylk/Sylk-${version}-x86_64.AppImage";
    hash = "sha256-VgepO7LHFmNKq/H0RFcIkafgtiVGt8K/LdiCO5Dw2s4=";
  };

  profile = ''
    export LC_ALL=C.UTF-8
  '';

  meta = {
    description = "Desktop client for SylkServer, a multiparty conferencing tool";
    homepage = "https://sylkserver.com/";
    license = lib.licenses.agpl3Plus;
    mainProgram = "Sylk";
    maintainers = with lib.maintainers; [ zimbatm ];
    platforms = [
      "i386-linux"
      "x86_64-linux"
    ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
