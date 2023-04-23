{ gsmakeDerivation
, cairo
, fetchzip
, base, gui
, fontconfig
, freetype
, pkg-config
, libXft
, libXmu
}:

gsmakeDerivation rec {
  pname = "gnustep-back";
  version = "0.29.0";

  src = fetchzip {
    url = "ftp://ftp.gnustep.org/pub/gnustep/core/${pname}-${version}.tar.gz";
    sha256 = "sha256-4n2SC68G0dpSz9nqCL5Kz76nyoRxWcRTWDwZsnMoHSM=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ cairo base gui fontconfig freetype libXft libXmu ];
  meta = {
    description = "A generic backend for GNUstep";
  };
}
