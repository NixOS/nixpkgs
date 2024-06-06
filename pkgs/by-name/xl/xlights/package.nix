{ lib, appimageTools, fetchurl }:

appimageTools.wrapType2 rec {
  pname = "xlights";
  version = "2024.10";

  src = fetchurl {
    url = "https://github.com/smeighan/xLights/releases/download/${version}/xLights-${version}-x86_64.AppImage";
    hash = "sha256-h5jChYlTzKenZl0EnScU+vA+535pICXKdUhj8zAU4wc=";
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
