{ stdenv, fetchurl, pkgconfig, xlibs }:

stdenv.mkDerivation rec {
  name = "libvdpau-0.6";

  src = fetchurl {
    url = "http://people.freedesktop.org/~aplattner/vdpau/${name}.tar.gz";
    sha256 = "0x9dwxzw0ilsy88kqlih3170z1zfrrsx1dr9jbwbn0cbkpnbwmcv";
  };

  buildInputs = with xlibs; [ pkgconfig dri2proto libXext ];

  propagatedBuildInputs = [ xlibs.libX11 ];

  meta = {
    homepage = http://people.freedesktop.org/~aplattner/vdpau/;
    description = "Library to use the Video Decode and Presentation API for Unix (VDPAU)";
    license = "bsd";
  };
}
