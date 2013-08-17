{ stdenv, fetchurl, intltool, pkgconfig, iconnamingutils, imagemagick, librsvg }:

stdenv.mkDerivation rec {
  name = "tango-icon-theme-0.8.90";

  src = fetchurl {
    url = "http://tango.freedesktop.org/releases/${name}.tar.gz";
    sha256 = "13n8cpml71w6zfm2jz5fa7r1z18qlzk4gv07r6n1in2p5l1xi63f";
  };

  patches = [ ./rsvg-convert.patch ];

  buildInputs = [ intltool pkgconfig iconnamingutils imagemagick librsvg ];

  configureFlags = "--enable-png-creation";

  meta = {
    description = "A basic set of icons";
    homepage = http://tango.freedesktop.org/Tango_Icon_Library;
    platforms = stdenv.lib.platforms.linux;
  };
}
