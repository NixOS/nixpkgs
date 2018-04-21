{ gsmakeDerivation, fetchurl, base }:
let
  version = "0.26.2";
in
gsmakeDerivation {
  name = "gnustep-gui-${version}";
  src = fetchurl {
    url = "ftp://ftp.gnustep.org/pub/gnustep/core/gnustep-gui-${version}.tar.gz";
    sha256 = "1dsbkifnjha3ghq8xx55bpsbbng0cjsni3yz71r7342ax2ixcvxc";
  };
  buildInputs = [ base ];
  patches = [ ./fixup-all.patch ];
  meta = {
    description = "A GUI class library of GNUstep";
  };
}
