{ gsmakeDerivation, fetchurl, base }:
let
  version = "0.25.0";
in
gsmakeDerivation {
  name = "gnustep-gui-${version}";
  src = fetchurl {
    url = "ftp://ftp.gnustep.org/pub/gnustep/core/gnustep-gui-${version}.tar.gz";
    sha256 = "10jf3xir59qzbhhl0bvs9wdw40fsmvv6mdv5akdkia1rnck60xf5";
  };
  buildInputs = [ base ];
  patches = [ ./fixup-all.patch ];
  meta = {
    description = "A GUI class library of GNUstep";
  };
}
