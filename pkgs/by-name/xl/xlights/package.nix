{
  lib,
  appimageTools,
  fetchurl,
}:

appimageTools.wrapType2 rec {
  pname = "xlights";
  version = "2025.05";

  src = fetchurl {
    url = "https://github.com/smeighan/xLights/releases/download/${version}/xLights-${version}-x86_64.AppImage";
    hash = "sha256-uutiM/kLsvNdDi08e5DyyTYGYwUe4UZMyTS1P0ijUP0=";
  };

  meta = {
    description = "xLights is a sequencer for Lights. xLights has usb and E1.31 drivers. You can create sequences in this object oriented program. You can create playlists, schedule them, test your hardware, convert between different sequencers";
    homepage = "https://xlights.org";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ kashw2 ];
    platforms = lib.platforms.linux;
    mainProgram = "xlights";
  };
}
