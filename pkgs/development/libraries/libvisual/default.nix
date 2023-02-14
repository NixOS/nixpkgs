{ lib
, stdenv
, fetchurl
, SDL
, glib
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "libvisual";
  version = "0.4.1";

  src = fetchurl {
    url = "mirror://sourceforge/libvisual/${pname}-${version}.tar.gz";
    hash = "sha256-qhKHdBf3bTZC2fTHIzAjgNgzF1Y51jpVZB0Bkopd230=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ SDL glib ];

  meta = {
    description = "An abstraction library for audio visualisations";
    homepage = "https://sourceforge.net/projects/libvisual/";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
}
