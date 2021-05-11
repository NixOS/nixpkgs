{ gsmakeDerivation
, cairo
, fetchurl
, base, gui
, xlibsWrapper
, freetype
, pkg-config
, libXmu
}:
let
  version = "0.29.0";
in
gsmakeDerivation {
  name = "gnustep-back-${version}";
  src = fetchurl {
    url = "ftp://ftp.gnustep.org/pub/gnustep/core/gnustep-back-${version}.tar.gz";
    sha256 = "sha256-GN1OkgCr7xZXCzMehyXS7PgI+obRJaknzJd26LiKmJI=";
  };
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ cairo base gui freetype xlibsWrapper libXmu ];
  meta = {
    description = "A generic backend for GNUstep";
  };
}
