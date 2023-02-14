{ lib
, stdenv
, fetchurl
, SDL
, glib
, pkg-config
  # sdl-config is not available when crossing
, withExamples ? stdenv.buildPlatform == stdenv.hostPlatform
}:

stdenv.mkDerivation rec {
  pname = "libvisual";
  version = "0.4.1";

  src = fetchurl {
    url = "mirror://sourceforge/libvisual/${pname}-${version}.tar.gz";
    hash = "sha256-qhKHdBf3bTZC2fTHIzAjgNgzF1Y51jpVZB0Bkopd230=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = lib.optional withExamples SDL ++ [ glib ];

  configureFlags = lib.optional (!withExamples) "--disable-examples";

  meta = {
    description = "An abstraction library for audio visualisations";
    homepage = "https://sourceforge.net/projects/libvisual/";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
}
