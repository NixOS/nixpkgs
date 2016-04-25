{ stdenv, fetchgit, autoconf, automake, libtool, pkgconfig
, git, xorg, gnum4, libxcb, gperf }:

stdenv.mkDerivation rec {
  name = "xcb-util-cursor-0.1.1-3-gf03cc27";

  src = fetchgit {
    url    = http://anongit.freedesktop.org/git/xcb/util-cursor.git;
    rev    = "f03cc278c6cce0cf721adf9c3764d3c5fba63392";
    sha256 = "1ljvq1gdc1lc33dwn4pzwppws2zgyqx51y3sd3c8gb7vcg5f27i5";
  };

  meta = with stdenv.lib; {
    description = "XCB cursor library (libxcursor port)";
    homepage    = http://cgit.freedesktop.org/xcb/util-cursor;
    license     = licenses.mit;
    maintainer  = with maintainers; [ lovek323 ];
    platforms   = platforms.linux ++ platforms.darwin;
  };

  outputs = [ "dev" "out" ];

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
