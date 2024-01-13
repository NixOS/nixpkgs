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
  version = "0.30.0";

  src = fetchzip {
    url = "ftp://ftp.gnustep.org/pub/gnustep/core/${pname}-${version}.tar.gz";
    sha256 = "sha256-HD4PLdkE573nPWqFwffUmcHw8VYIl5rLiPKWrbnwpCI=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ cairo base gui fontconfig freetype libXft libXmu ];
  meta = {
    description = "A generic backend for GNUstep";
  };
}
