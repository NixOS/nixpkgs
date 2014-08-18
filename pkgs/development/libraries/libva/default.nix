{ stdenv, fetchurl, libX11, pkgconfig, libXext, mesa, libdrm, libXfixes }:

stdenv.mkDerivation rec {
  name = "libva-1.1.1";
  
  src = fetchurl {
    url = "http://www.freedesktop.org/software/vaapi/releases/libva/${name}.tar.bz2";
    sha256 = "0kfdcrzcr82g15l0vvmm6rqr0f0604d4dgrza78gn6bfx7rppby0";
  };

  buildInputs = [ libX11 libXext pkgconfig mesa libdrm libXfixes ];

  configureFlags = [ "--enable-glx" ];

  meta = {
    homepage = http://www.freedesktop.org/wiki/Software/vaapi;
    license = "MIT";
    description = "VAAPI library: Video Acceleration API";
  };
}
