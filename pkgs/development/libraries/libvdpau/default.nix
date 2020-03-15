{ stdenv, fetchurl, pkgconfig, xorg, mesa, meson, ninja }:

stdenv.mkDerivation rec {
  pname = "libvdpau";
  version = "1.3";

  src = fetchurl {
    url = "https://gitlab.freedesktop.org/vdpau/libvdpau/-/archive/${version}/${pname}-${version}.tar.bz2";
    sha256 = "b5a52eeac9417edbc396f26c40591ba5df0cd18285f68d84614ef8f06196e50e";
  };
  patches = [ ./installdir.patch ];

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ meson ninja pkgconfig ];
  buildInputs = with xorg; [ xorgproto libXext ];

  propagatedBuildInputs = [ xorg.libX11 ];

  mesonFlags = stdenv.lib.optional stdenv.isLinux
    [ "-Dmoduledir=${mesa.drivers.driverLink}/lib/vdpau" ];

  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.isDarwin "-lX11";

  meta = with stdenv.lib; {
    homepage = https://people.freedesktop.org/~aplattner/vdpau/;
    description = "Library to use the Video Decode and Presentation API for Unix (VDPAU)";
    license = licenses.mit; # expat version
    platforms = platforms.unix;
    maintainers = [ maintainers.vcunat ];
  };
}
