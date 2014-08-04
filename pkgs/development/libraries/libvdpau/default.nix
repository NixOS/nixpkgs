{ stdenv, fetchurl, pkgconfig, xorg }:

stdenv.mkDerivation rec {
  name = "libvdpau-0.8";

  src = fetchurl {
    url = "http://people.freedesktop.org/~aplattner/vdpau/${name}.tar.gz";
    sha256 = "1v81875hppablq9gpsmvhnyl7z80zihx6arry758pvdbq4fd39vk";
  };

  buildInputs = with xorg; [ pkgconfig dri2proto libXext ];

  propagatedBuildInputs = [ xorg.libX11 ];

  configureFlags = stdenv.lib.optional stdenv.isDarwin [ "--build=x86_64" ];

  meta = with stdenv.lib; {
    homepage = http://people.freedesktop.org/~aplattner/vdpau/;
    description = "Library to use the Video Decode and Presentation API for Unix (VDPAU)";
    license = licenses.mit;
  };
}
