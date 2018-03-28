{ stdenv, fetchurl, pkgconfig, xorg, libGL }:

stdenv.mkDerivation rec {
  name = "libvdpau-1.1.1";

  src = fetchurl {
    url = "https://people.freedesktop.org/~aplattner/vdpau/${name}.tar.bz2";
    sha256 = "857a01932609225b9a3a5bf222b85e39b55c08787d0ad427dbd9ec033d58d736";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = with xorg; [ dri2proto libXext ];

  propagatedBuildInputs = [ xorg.libX11 ];

  configureFlags = stdenv.lib.optional stdenv.isLinux
    "--with-module-dir=${libGL.driverLink}/lib/vdpau";

  installFlags = [ "moduledir=$(out)/lib/vdpau" ];

  meta = with stdenv.lib; {
    homepage = https://people.freedesktop.org/~aplattner/vdpau/;
    description = "Library to use the Video Decode and Presentation API for Unix (VDPAU)";
    license = licenses.mit; # expat version
    platforms = platforms.unix;
    maintainers = [ maintainers.vcunat ];
  };
}
