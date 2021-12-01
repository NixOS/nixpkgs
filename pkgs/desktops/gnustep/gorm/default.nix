{ fetchzip, base, back, gsmakeDerivation, gui }:
gsmakeDerivation rec {
  pname = "gorm";
  version = "1.2.28";

  src = fetchzip {
    url = "ftp://ftp.gnustep.org/pub/gnustep/dev-apps/gorm-${version}.tar.gz";
    sha256 = "0n92xr16w0wnwfzh7i9xhsly61pyz9l9f615dp324a6r3444hn0z";
  };
  buildInputs = [ base back gui ];

  meta = {
    description = "Graphical Object Relationship Modeller is an easy-to-use interface designer for GNUstep";
  };
}
