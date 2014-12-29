{ stdenv, fetchurl, libX11, pkgconfig, libXext, mesa, libdrm, libXfixes, wayland, libffi }:

stdenv.mkDerivation rec {
  name = "libva-1.4.1";
  
  src = fetchurl {
    url = "http://www.freedesktop.org/software/vaapi/releases/libva/${name}.tar.bz2";
    sha256 = "04ac7wzw8b3axjf5pgz75khlym89c3v5nvz88yxx5kzirl7ayqh6";
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
