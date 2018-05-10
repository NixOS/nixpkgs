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
  version = "0.26.2";
in
gsmakeDerivation {
  name = "gnustep-back-${version}";
  src = fetchurl {
    url = "ftp://ftp.gnustep.org/pub/gnustep/core/gnustep-back-${version}.tar.gz";
    sha256 = "012gsc7x66gmsw6r5w65a64krcigf7rzqzd5x86d4gv94344knlf";
  };
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ cairo base gui freetype x11 libXmu ];
  meta = {
    description = "A generic backend for GNUstep";
  };
}
