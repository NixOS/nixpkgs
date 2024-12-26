{
  lib,
  stdenv,
  fetchgit,
  autoconf,
  automake,
  libtool,
  pkg-config,
  xorg,
  gnum4,
  libxcb,
  gperf,
}:

stdenv.mkDerivation {
  pname = "xcb-util-cursor-0.1.1-3-unstable";
  version = "2017-04-05";

  src = fetchgit {
    url = "http://anongit.freedesktop.org/git/xcb/util-cursor.git";
    rev = "f03cc278c6cce0cf721adf9c3764d3c5fba63392";
    sha256 = "127zfmihd8nqlj8jjaja06xb84xdgl263w0av1xnprx05mkbkcyc";
  };

  meta = with lib; {
    description = "XCB cursor library (libxcursor port)";
    homepage = "https://cgit.freedesktop.org/xcb/util-cursor";
    license = licenses.mit;
    maintainers = with maintainers; [ lovek323 ];
    platforms = platforms.linux ++ platforms.darwin;
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    autoconf
    automake
    pkg-config
  ];
  buildInputs = [
    gnum4
    gperf
    libtool
    libxcb
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
