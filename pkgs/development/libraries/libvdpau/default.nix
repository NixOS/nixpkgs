{ stdenv, fetchurl, pkgconfig, libX11 }:

stdenv.mkDerivation rec {
  name = "libvdpau-0.4.1";
  
  src = fetchurl {
    url = "http://people.freedesktop.org/~aplattner/vdpau/${name}.tar.gz";
    sha256 = "16zmmbawfnvrxjqvgfwxjfd1wh3vyz2cmvxza6cgf4j9qs36y6q6";
  };

  buildInputs = [ pkgconfig libX11 ];

  propagatedBuildInputs = [ libX11 ];

  meta = {
    homepage = http://people.freedesktop.org/~aplattner/vdpau/;
    description = "Library to use the Video Decode and Presentation API for Unix (VDPAU)";
    license = "bsd";
  };
}
