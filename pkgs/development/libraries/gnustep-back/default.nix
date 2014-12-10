{ buildEnv
, cairo
, clang
, fetchurl
, gnustep_base, gnustep_make, gnustep_gui
, xlibs
, x11
, freetype
, pkgconfig
, stdenv
}:
let
  version = "0.24.0";
in
stdenv.mkDerivation rec {
  name = "gnustep-back-${version}";
  src = fetchurl {
    url = "ftp://ftp.gnustep.org/pub/gnustep/core/gnustep-back-0.24.0.tar.gz";
    sha256 = "0qixbilkkrqxrhhj9hnp7ygd5gs23b3qbbgk3gaxj73d0xqfvhjz";
  };
  buildInputs = [ cairo clang gnustep_base gnustep_gui gnustep_make freetype pkgconfig x11 ];
  meta = {
    description = "GNUstep-back is a generic backend for GNUstep.";
    
    homepage = http://gnustep.org/;

    license = stdenv.lib.licenses.lgpl2Plus;

    maintainers = with stdenv.lib.maintainers; [ ashalkhakov ];
    platforms = stdenv.lib.platforms.linux;
  };
}
