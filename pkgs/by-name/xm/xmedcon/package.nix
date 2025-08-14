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
  version = "0.25.3";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-9VrTQP614tIrmZRm9bSpmlXqCbMPzqvhv222eFiKS4M=";
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

  meta = with lib; {
    description = "Open source toolkit for medical image conversion";
    homepage = "https://xmedcon.sourceforge.net/";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [
      arianvp
      flokli
    ];
    platforms = platforms.darwin ++ platforms.linux;
  };
}
