{ stdenv, fetchurl, libX11, pkgconfig, libXext, mesa, libdrm, libXfixes, wayland, libffi }:

stdenv.mkDerivation rec {
  name = "libva-1.3.1";
  
  src = fetchurl {
    url = "http://www.freedesktop.org/software/vaapi/releases/libva/${name}.tar.bz2";
    sha256 = "15y27jdnfvf9krg4s3a1c29rn9pvyp43wckpwhd2rg4wrbqv32c7";
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
