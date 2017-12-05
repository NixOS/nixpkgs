{ stdenv, fetchgit, autoconf, automake, libtool, pkgconfig
, git, xorg, gnum4, libxcb, gperf }:

stdenv.mkDerivation rec {
  name = "xcb-util-cursor-0.1.1-3-unstable-${version}";
  version = "2017-04-05";

  src = fetchgit {
    url    = http://anongit.freedesktop.org/git/xcb/util-cursor.git;
    rev    = "f03cc278c6cce0cf721adf9c3764d3c5fba63392";
    sha256 = "127zfmihd8nqlj8jjaja06xb84xdgl263w0av1xnprx05mkbkcyc";
  };

  meta = with stdenv.lib; {
    description = "XCB cursor library (libxcursor port)";
    homepage    = http://cgit.freedesktop.org/xcb/util-cursor;
    license     = licenses.mit;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.linux ++ platforms.darwin;
  };

  outputs = [ "out" "dev" ];

  buildInputs = [
    autoconf
    automake
    gnum4
    gperf
    libtool
    libxcb
    pkgconfig
    xorg.utilmacros
    xorg.xcbutilimage
    xorg.xcbutilrenderutil
  ];

  configurePhase = ''
    sed -i '15 i\
      LT_INIT' configure.ac
    ${stdenv.shell} autogen.sh --prefix="$out"
  '';
}
