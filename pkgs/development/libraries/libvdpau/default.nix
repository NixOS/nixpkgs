{ stdenv, fetchurl, pkgconfig, libX11 }:

stdenv.mkDerivation rec {
  name = "libvdpau-0.5";
  
  src = fetchurl {
    url = "http://people.freedesktop.org/~aplattner/vdpau/${name}.tar.gz";
    sha256 = "0k2ydz4yp7zynlkpd1llfwax30xndwbca36z83ah1i4ldjw2gfhx";
  };

  buildInputs = [ pkgconfig libX11 ];

  propagatedBuildInputs = [ libX11 ];

  meta = {
    homepage = http://people.freedesktop.org/~aplattner/vdpau/;
    description = "Library to use the Video Decode and Presentation API for Unix (VDPAU)";
    license = "bsd";
  };
}
