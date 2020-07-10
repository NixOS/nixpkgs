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
  version = "0.28.0";
in
gsmakeDerivation {
  name = "gnustep-back-${version}";
  src = fetchurl {
    url = "ftp://ftp.gnustep.org/pub/gnustep/core/gnustep-back-${version}.tar.gz";
    sha256 = "1ynd27zwga17mp2qlym90k2xsypdvz24w6gyy2rfvmv0gkvlgrjr";
  };
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ cairo base gui freetype xlibsWrapper libXmu ];
  meta = {
    description = "A generic backend for GNUstep";
  };
}
