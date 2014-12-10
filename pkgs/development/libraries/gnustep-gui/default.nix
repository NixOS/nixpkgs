{
  clang
, fetchurl
, gnustep_make
, gnustep_base
#, xlibs, x11, freetype
#, pkgconfig
, stdenv }:
let
  version = "0.24.0";
in
stdenv.mkDerivation rec {
  name = "gnustep-gui-${version}";
  src = fetchurl {
    url = "ftp://ftp.gnustep.org/pub/gnustep/core/gnustep-gui-0.24.0.tar.gz";
    sha256 = "0d6jzfcyacxjzrr2p398ysvs1akv1fcmngfzxxbfxa947miydjxg";
  };
  buildInputs = [ clang gnustep_make gnustep_base ];
  propagatedBuildInputs = [ gnustep_base ];
  patches = [ ./fixup-gui-makefile-installdir.patch ./fixup-gui-tools-preamble.patch ./fixup-gui-textconverters-preamble.patch ];
  meta = {
    description = "GNUstep-gui is a GUI class library of GNUstep.";
    
    homepage = http://gnustep.org/;

    license = stdenv.lib.licenses.lgpl2Plus;

    maintainers = with stdenv.lib.maintainers; [ ashalkhakov ];
    platforms = stdenv.lib.platforms.linux;
  };
}
