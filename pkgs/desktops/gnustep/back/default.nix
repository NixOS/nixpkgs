{ gsmakeDerivation
, cairo
, fetchurl
, base, gui
, xlibsWrapper
, freetype
, pkgconfig
, libXmu
}:
let
  version = "0.27.0";
in
gsmakeDerivation {
  name = "gnustep-back-${version}";
  src = fetchurl {
    url = "ftp://ftp.gnustep.org/pub/gnustep/core/gnustep-back-${version}.tar.gz";
    sha256 = "0j400892ysxygh50i3918nn87vkxh15h892jwvphmkd34j8wdn9f";
  };
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ cairo base gui freetype xlibsWrapper libXmu ];
  meta = {
    description = "A generic backend for GNUstep";
  };
}
