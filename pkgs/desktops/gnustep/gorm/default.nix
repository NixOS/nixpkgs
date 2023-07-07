{ fetchzip, base, back, gsmakeDerivation, gui }:
gsmakeDerivation rec {
  pname = "gorm";
  version = "1.3.1";

  src = fetchzip {
    url = "ftp://ftp.gnustep.org/pub/gnustep/dev-apps/gorm-${version}.tar.gz";
    sha256 = "sha256-W+NgbvLjt1PpDiauhzWFaU1/CUhmDACQz+GoyRUyWB8=";
  };
  buildInputs = [ base back gui ];

  meta = {
    description = "Graphical Object Relationship Modeller is an easy-to-use interface designer for GNUstep";
  };
}
