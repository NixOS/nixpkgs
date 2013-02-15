{ stdenv, fetchurl, libX11, pkgconfig, libXext, mesa, libdrm, libXfixes }:

stdenv.mkDerivation rec {
  name = "libva-1.1.0";
  
  src = fetchurl {
    url = "http://www.freedesktop.org/software/vaapi/releases/libva/${name}.tar.bz2";
    sha256 = "1a7g7i96ww8hmim2pq2a3xc89073lzacxn1xh9526bzhlqjdqsnv";
  };

  buildInputs = [ libX11 libXext pkgconfig mesa libdrm libXfixes ];

  configureFlags = [ "--enable-glx" ];

  meta = {
    homepage = http://www.freedesktop.org/wiki/Software/vaapi;
    license = "MIT";
    description = "VAAPI library: Video Acceleration API";
  };
}
