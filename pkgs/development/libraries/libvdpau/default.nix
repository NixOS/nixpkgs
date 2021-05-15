{ lib, stdenv, fetchurl, pkg-config, xorg, mesa, meson, ninja }:

stdenv.mkDerivation rec {
  pname = "libvdpau";
  version = "1.4";

  src = fetchurl {
    url = "https://gitlab.freedesktop.org/vdpau/libvdpau/-/archive/${version}/${pname}-${version}.tar.bz2";
    sha256 = "0c1zsfr6ypzwv8g9z50kdahpb7pirarq4z8avqqyyma5b9684n22";
  };
  patches = [ ./installdir.patch ];

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ meson ninja pkg-config ];
  buildInputs = with xorg; [ xorgproto libXext ];

  propagatedBuildInputs = [ xorg.libX11 ];

  mesonFlags = lib.optional stdenv.isLinux
    [ "-Dmoduledir=${mesa.drivers.driverLink}/lib/vdpau" ];

  NIX_LDFLAGS = lib.optionalString stdenv.isDarwin "-lX11";

  meta = with lib; {
    homepage = "https://people.freedesktop.org/~aplattner/vdpau/";
    description = "Library to use the Video Decode and Presentation API for Unix (VDPAU)";
    license = licenses.mit; # expat version
    platforms = platforms.unix;
    maintainers = [ maintainers.vcunat ];
  };
}
