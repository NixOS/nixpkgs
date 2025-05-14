{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  pkg-config,
  libvdpau,
}:

stdenv.mkDerivation rec {
  pname = "vdpauinfo";
  version = "1.5";

  src = fetchurl {
    url = "https://gitlab.freedesktop.org/vdpau/vdpauinfo/-/archive/${version}/${pname}-${version}.tar.bz2";
    hash = "sha256-uOs/r8Ow7KvSpY1NhD2A+D4Qs6iWJe4fZGfVj6nIiCw=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [ libvdpau ];

  meta = with lib; {
    homepage = "https://people.freedesktop.org/~aplattner/vdpau/";
    description = "Tool to query the Video Decode and Presentation API for Unix (VDPAU) abilities of the system";
    license = licenses.mit; # expat version
    platforms = platforms.unix;
    maintainers = with maintainers; [ vcunat ];
    mainProgram = "vdpauinfo";
  };
}
