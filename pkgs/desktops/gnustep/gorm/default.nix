{ fetchurl, base, back, gsmakeDerivation, gui }:
let
  version = "1.2.28";
in
gsmakeDerivation {
  name = "gorm-${version}";

  src = fetchurl {
    url = "ftp://ftp.gnustep.org/pub/gnustep/dev-apps/gorm-${version}.tar.gz";
    sha256 = "sha256-ik83f1djfkFbL92T4JReNlL5wl9TIFqgytAZjtFTfDc=";
  };
  buildInputs = [ base back gui ];

  meta = {
    description = "Graphical Object Relationship Modeller is an easy-to-use interface designer for GNUstep";
  };
}
