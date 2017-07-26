{ gsmakeDerivation
, cairo
, fetchurl
, base, gui
, x11
, freetype
, pkgconfig
, libXmu
}:
let
  version = "0.25.0";
in
gsmakeDerivation {
  name = "gnustep-back-${version}";
  src = fetchurl {
    url = "ftp://ftp.gnustep.org/pub/gnustep/core/gnustep-back-${version}.tar.gz";
    sha256 = "14gs1b32ahnihd7mwpjrws2b8hl11rl1wl24a7651d3z2l7f6xj2";
  };
  buildInputs = [ cairo base gui freetype pkgconfig x11 libXmu ];
  meta = {
    description = "A generic backend for GNUstep";
  };
}
