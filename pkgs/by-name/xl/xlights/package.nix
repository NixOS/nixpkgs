{
  lib,
  appimageTools,
  fetchurl,
}:

appimageTools.wrapType2 rec {
  pname = "xlights";
  version = "2025.10.2";

  src = fetchurl {
    url = "https://github.com/smeighan/xLights/releases/download/${version}/xLights-${version}-x86_64.AppImage";
    hash = "sha256-LfT1AQktBklN1IUiJdqxFY4bM/CQEBg/5sxEvWUQkGQ=";
  };

  meta = {
    description = "Sequencer for lights with USB and E1.31 drivers";
    homepage = "https://xlights.org";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ kashw2 ];
    platforms = lib.platforms.linux;
    mainProgram = "xlights";
  };
}
