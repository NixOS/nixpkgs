{ fetchurl, base, back, gsmakeDerivation, gui }:
let
  version = "1.2.24";
in
gsmakeDerivation {
  name = "gorm-${version}";
  
  src = fetchurl {
    url = "ftp://ftp.gnustep.org/pub/gnustep/dev-apps/gorm-${version}.tar.gz";
    sha256 = "1jw7vm5ia7ias1mm5if7vvvb66q50zwiqw0ksj5g14f11v8l61rf";
  };
  buildInputs = [ base back gui ];

  meta = {
    description = "Graphical Object Relationship Modeller is an easy-to-use interface designer for GNUstep";
  };
}
