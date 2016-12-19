{ fetchurl, base, back, gsmakeDerivation, gui }:
let
  version = "1.2.22";
in
gsmakeDerivation {
  name = "gorm-${version}";
  
  src = fetchurl {
    url = "ftp://ftp.gnustep.org/pub/gnustep/dev-apps/gorm-${version}.tar.gz";
    sha256 = "1mq5n65xd9bc4kppx19iijsgpz4crvhg7bfwbi9k78j159vclnmi";
  };
  buildInputs = [ base back gui ];

  meta = {
    description = "Graphical Object Relationship Modeller is an easy-to-use interface designer for GNUstep";
  };
}
