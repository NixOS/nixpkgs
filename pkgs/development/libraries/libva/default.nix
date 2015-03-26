{ stdenv, fetchurl, libX11, pkgconfig, libXext, mesa, libdrm, libXfixes, wayland, libffi }:

stdenv.mkDerivation rec {
  name = "libva-1.5.1";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/vaapi/releases/libva/${name}.tar.bz2";
    sha256 = "01d01mm9fgpwzqycmjjcj3in3vvzcibi3f64icsw2sksmmgb4495";
  };

  buildInputs = [ libX11 libXext pkgconfig mesa libdrm libXfixes wayland libffi ];

  configureFlags = [ "--enable-glx" ];

  meta = with stdenv.lib; {
    homepage = http://www.freedesktop.org/wiki/Software/vaapi;
    license = licenses.mit;
    description = "VAAPI library: Video Acceleration API";
    platforms = platforms.unix;
  };
}
