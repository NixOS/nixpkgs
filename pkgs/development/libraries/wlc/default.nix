{ lib, stdenv, fetchurl, fetchgit, cmake, pkgconfig, fetchFromGitHub
, glibc, wayland, pixman, libxkbcommon, libinput, libxcb, xcbutilwm, xcbutilimage, mesa, libdrm, udev, systemd, dbus_libs
, libpthreadstubs, libX11, libXau, libXdmcp, libXext, libXdamage, libxshmfence, libXxf86vm
}:

stdenv.mkDerivation rec {
  name = "wlc-${version}";
  version = "0.0.5";

  src = fetchgit {
    url = "https://github.com/Cloudef/wlc";
    rev = "refs/tags/v${version}";
    sha256 = "0pg95n488fjlkc8n8x1h2dh4mxb7qln6mrq906lwwqv94aks9b43";
    fetchSubmodules = true;
   };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [
    wayland pixman libxkbcommon libinput libxcb xcbutilwm xcbutilimage mesa libdrm udev
    libX11 libXdamage systemd dbus_libs
  ];


  doCheck = true;
  checkTarget = "test";

  meta = {
    description = "A library for making a simple Wayland compositor";
    homepage    = https://github.com/Cloudef/wlc;
    license     = lib.licenses.mit;
    platforms   = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ];
  };
}
