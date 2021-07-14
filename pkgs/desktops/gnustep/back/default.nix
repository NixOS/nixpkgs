{ gsmakeDerivation
, cairo
, fetchzip
, base, gui
, xlibsWrapper
, freetype
, pkg-config
, libXmu
}:

gsmakeDerivation rec {
  pname = "gnustep-back";
  version = "0.28.0";

  src = fetchzip {
    url = "ftp://ftp.gnustep.org/pub/gnustep/core/${pname}-${version}.tar.gz";
    sha256 = "1nkmk7qli2ld6gw9h4kqa199i8q2m9x9d46idxh1k0rb41kf3i2c";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ cairo base gui freetype xlibsWrapper libXmu ];
  meta = {
    description = "A generic backend for GNUstep";
  };
}
