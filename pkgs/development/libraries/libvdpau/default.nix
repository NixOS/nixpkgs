{ stdenv, fetchurl, pkgconfig, xlibs }:

stdenv.mkDerivation rec {
  name = "libvdpau-0.7";

  src = fetchurl {
    url = "http://people.freedesktop.org/~aplattner/vdpau/${name}.tar.gz";
    sha256 = "1q5wx6fmqg2iiw57wxwh5vv4yszqs4nlvlzhzdn9vig8gi30ip14";
  };

  buildInputs = with xlibs; [ pkgconfig dri2proto libXext ];

  propagatedBuildInputs = [ xlibs.libX11 ];

  configureFlags = stdenv.lib.optional stdenv.isDarwin [ "--build=x86_64" ];

  meta = {
    homepage = http://people.freedesktop.org/~aplattner/vdpau/;
    description = "Library to use the Video Decode and Presentation API for Unix (VDPAU)";
    license = "bsd";
  };
}
