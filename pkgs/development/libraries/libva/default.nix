{ stdenv, fetchurl, libX11, pkgconfig, libXext, mesa, libdrm, libXfixes }:

stdenv.mkDerivation rec {
  name = "libva-1.2.1";
  
  src = fetchurl {
    url = "http://www.freedesktop.org/software/vaapi/releases/libva/${name}.tar.bz2";
    sha256 = "0fx8ivaghpq8g099bzwy5dm3bqnkbbhjq3qhgrpk390c4s5hy23h";
  };

  buildInputs = [ libX11 libXext pkgconfig mesa libdrm libXfixes ];

  configureFlags = [ "--enable-glx" ];

  meta = {
    homepage = http://www.freedesktop.org/wiki/Software/vaapi;
    license = "MIT";
    description = "VAAPI library: Video Acceleration API";
  };
}
