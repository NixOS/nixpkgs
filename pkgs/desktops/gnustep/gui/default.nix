{ gsmakeDerivation, fetchurl, fetchpatch, base }:
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
  patches = [
    ./fixup-all.patch
    (fetchpatch {  # for icu68 compatibility, remove with next update(?)
      url = "https://github.com/gnustep/libs-gui/commit/05572b2d01713f5caf07f334f17ab639be8a1cff.patch";
      sha256 = "04z287dk8jf3hdwzk8bpnv49qai2dcdlh824yc9bczq291pjy2xc";
    })
  ];
  meta = {
    description = "A GUI class library of GNUstep";
  };
}
