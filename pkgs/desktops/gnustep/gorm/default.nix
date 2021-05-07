{ fetchzip, base, back, gsmakeDerivation, gui }:
gsmakeDerivation rec {
  pname = "gorm";
  version = "1.2.26";

  src = fetchzip {
    url = "ftp://ftp.gnustep.org/pub/gnustep/dev-apps/gorm-${version}.tar.gz";
    sha256 = "1j0n8rdwvp9082vgkw8w430gvljli04zclkxi9gpdr43nj97gwdf";
  };
  buildInputs = [ base back gui ];

  meta = {
    description = "Graphical Object Relationship Modeller is an easy-to-use interface designer for GNUstep";
  };
}
