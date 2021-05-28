{ gsmakeDerivation, fetchurl, base }:
let
  version = "0.28.0";
in
gsmakeDerivation {
  name = "gnustep-gui-${version}";
  src = fetchurl {
    url = "ftp://ftp.gnustep.org/pub/gnustep/core/gnustep-gui-${version}.tar.gz";
    sha256 = "05wk8kbl75qj0jgawgyv9sp98wsgz5vl1s0d51sads0p0kk2sv8z";
  };
  buildInputs = [ base ];
  patches = [ ./fixup-all.patch ];
  meta = {
    description = "A GUI class library of GNUstep";
  };
}
