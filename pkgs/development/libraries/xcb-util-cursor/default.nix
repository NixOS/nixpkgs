{ stdenv, fetchurl, bashInteractive, autoconf, automake, libtool, pkgconfig
, git, xlibs, gnum4, libxcb, gperf }:

stdenv.mkDerivation rec {
  name = "xcb-util-cursor-0.1.1";

  src = fetchurl {
    url    = "http://xcb.freedesktop.org/dist/xcb-util-cursor-0.1.1.tar.gz";
    sha256 = "0lkjbcml305imyzr80yb8spjvq6y83v2allk5gc9plkv39zag29z";
  };

  meta = with stdenv.lib; {
    description = "XCB cursor library (libxcursor port)";
    homepage    = http://cgit.freedesktop.org/xcb/util-cursor;
    license     = licenses.mit;
    maintainer  = with maintainers; [ lovek323 ];
    platforms   = platforms.linux;
  };

  buildInputs = [
    autoconf
    automake
    gnum4
    gperf
    libtool
    libxcb
    pkgconfig
    xlibs.utilmacros
    xlibs.xcbutilimage
    xlibs.xcbutilrenderutil
  ];

  configurePhase = ''
    sed -i '15 i\
      LT_INIT' configure.ac
    ${bashInteractive}/bin/bash autogen.sh --prefix="$out"
  '';
}
