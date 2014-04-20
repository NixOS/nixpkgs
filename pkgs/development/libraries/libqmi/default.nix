{ stdenv, fetchurl, pkgconfig, glib, python }:

stdenv.mkDerivation rec {
  name = "libqmi-1.8.0";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/libqmi/${name}.tar.xz";
    sha256 = "03gf221yjcdzvnl4v2adwpc6cyg5mlbccn20s00fp5bgvmq81pgs";
  };

  preBuild = ''
    patchShebangs .
  '';

  buildInputs = [ pkgconfig glib python ];

  meta = with stdenv.lib; {
    description = "Modem protocol helper library";
    platforms = platforms.linux;
  };
}
