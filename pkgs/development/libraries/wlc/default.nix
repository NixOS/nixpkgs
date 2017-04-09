{ lib, stdenv, fetchgit, cmake, pkgconfig
, glibc, wayland, pixman, libxkbcommon, libinput, libxcb, xcbutilwm, xcbutilimage, mesa, libdrm, udev, systemd, dbus_libs
, libpthreadstubs, libX11, libXau, libXdmcp, libXext, libXdamage, libxshmfence, libXxf86vm
, wayland-protocols
}:

stdenv.mkDerivation rec {
  name = "wlc-${version}";
  version = "0.0.8";

  src = fetchgit {
    url = "https://github.com/Cloudef/wlc";
    rev = "refs/tags/v${version}";
    sha256 = "1lkxbqnxfmbk9j9k8wq2fl5z0a9ihzalad3x1pp8w2riz41j3by6";
    fetchSubmodules = true;
   };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [
    wayland pixman libxkbcommon libinput libxcb xcbutilwm xcbutilimage mesa libdrm udev
    libX11 libXdamage systemd dbus_libs wayland-protocols
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
