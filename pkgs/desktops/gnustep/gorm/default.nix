{ fetchurl, base, back, gsmakeDerivation, gui }:
let
  version = "1.2.26";
in
gsmakeDerivation {
  name = "gorm-${version}";

  src = fetchurl {
    url = "ftp://ftp.gnustep.org/pub/gnustep/dev-apps/gorm-${version}.tar.gz";
    sha256 = "063f8rlz8py931hfrh95jxvr68bzs33bvckfigzbagp73n892jnw";
  };
  buildInputs = [ base back gui ];

  meta = {
    description = "Graphical Object Relationship Modeller is an easy-to-use interface designer for GNUstep";
  };
}
