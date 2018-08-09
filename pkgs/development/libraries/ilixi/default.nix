{ stdenv, fetchurl, pkgconfig, directfb, libsigcxx, libxml2, fontconfig }:

# TODO: optional deps: baresip, FusionDale, FusionSound, SaWMan, doxygen,
# Reflex, Wnn, NLS

stdenv.mkDerivation rec {
  name = "ilixi-1.0.0";

  src = fetchurl {
    url = "http://www.directfb.org/downloads/Libs/${name}.tar.gz";
    sha256 = "1kmdmqf68jiv7y6as41bhbgdy70yy2i811a3l6kccbazlzpif34v";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ directfb libsigcxx libxml2 fontconfig ];

  configureFlags = [
    "--enable-log-debug"
    "--enable-debug"
    "--enable-trace"
    "--with-examples"
  ];

  meta = with stdenv.lib; {
    description = "Lightweight C++ GUI toolkit for embedded Linux systems";
    homepage = http://ilixi.org/;
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
    broken = true; # broken by the directfb 1.6.3 -> 1.7.6 update
  };
}
