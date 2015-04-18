{ stdenv, fetchurl, pkgconfig, xorg }:

stdenv.mkDerivation rec {
  name = "libvdpau-1.1";

  src = fetchurl {
    url = "http://people.freedesktop.org/~aplattner/vdpau/${name}.tar.gz";
    sha256 = "069r4qc934xw3z20hpmg0gx0al7fl1kdik1r46x2dgr0ya1yg95f";
  };

  buildInputs = with xorg; [ pkgconfig dri2proto libXext ];

  propagatedBuildInputs = [ xorg.libX11 ];

  configureFlags = stdenv.lib.optional stdenv.isDarwin "--build=x86_64";

  meta = with stdenv.lib; {
    homepage = http://people.freedesktop.org/~aplattner/vdpau/;
    description = "Library to use the Video Decode and Presentation API for Unix (VDPAU)";
    license = licenses.mit; # expat version
    platforms = platforms.unix;
    maintainers = [ maintainers.vcunat ];
  };
}
