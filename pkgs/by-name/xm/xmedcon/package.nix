{
  stdenv,
  lib,
  fetchurl,
  gtk3,
  glib,
  pkg-config,
  libpng,
  zlib,
  wrapGAppsHook3,
}:

stdenv.mkDerivation rec {
  pname = "xmedcon";
  version = "0.25.2";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-vg14IRLukAOBtAE32AIyXTRzLzwKCGsvIFYRas/hyNs=";
  };

  buildInputs = [
    gtk3
    glib
    libpng
    zlib
  ];

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ];

  meta = {
    description = "Open source toolkit for medical image conversion";
    homepage = "https://xmedcon.sourceforge.net/";
    license = lib.licenses.lgpl2Plus;
    maintainers = with lib.maintainers; [
      arianvp
      flokli
    ];
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
  };
}
