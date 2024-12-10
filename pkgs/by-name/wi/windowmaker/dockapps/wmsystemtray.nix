{ lib
, stdenv
, fetchurl
, libX11
, libXext
, libXfixes
, libXmu
, libXpm
, pkg-config
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wmsystemtray";
  version = "1.4";

  src = fetchurl {
    url = "mirror://sourceforge/project/wmsystemtray/wmsystemtray/wmsystemtray-${finalAttrs.version}.tar.gz";
    hash = "sha256-jt70NpHp//BxAA4pFmx8GtQgwJVukGgVEGHogcisl+k=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libX11
    libXext
    libXfixes
    libXmu
    libXpm
  ];

  meta = {
    description = "System tray for Windowmaker";
    homepage = "http://wmsystemtray.sourceforge.net";
    license = lib.licenses.gpl2Only;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
