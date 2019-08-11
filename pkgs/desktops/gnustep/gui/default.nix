{ gsmakeDerivation, fetchurl, base }:
let
  version = "0.27.0";
in
gsmakeDerivation {
  name = "gnustep-gui-${version}";
  src = fetchurl {
    url = "ftp://ftp.gnustep.org/pub/gnustep/core/gnustep-gui-${version}.tar.gz";
    sha256 = "1m6k3fa2ndxv0kl2fazi76mwa27gn5jyp24q0rk96f2djhsy94br";
  };
  buildInputs = [ base ];
  patches = [ ./fixup-all.patch ];
  meta = {
    description = "A GUI class library of GNUstep";
  };
}
