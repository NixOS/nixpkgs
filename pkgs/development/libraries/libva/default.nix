{ stdenv, fetchurl, libX11, pkgconfig, libXext, mesa, libdrm, libXfixes, wayland, libffi }:

stdenv.mkDerivation rec {
  name = "libva-1.5.0";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/vaapi/releases/libva/${name}.tar.bz2";
    sha256 = "11ilp32fy7s42ii2dlcnf7305r9pi610r3jqdbn26khf26rx8ip9";
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
