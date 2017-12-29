{ lib, stdenv, fetchgit, cmake, pkgconfig
, glibc, wayland, pixman, libxkbcommon, libinput, libxcb, xcbutilwm, xcbutilimage, mesa, libdrm, udev, systemd, dbus_libs
, libpthreadstubs, libX11, libXau, libXdmcp, libXext, libXdamage, libxshmfence, libXxf86vm
, wayland-protocols
}:

stdenv.mkDerivation rec {
  name = "wlc-${version}";
  version = "0.0.9";

  src = fetchgit {
    url = "https://github.com/Cloudef/wlc";
    rev = "refs/tags/v${version}";
    sha256 = "1r6jf64gs7n9a8129wsc0mdwhcv44p8k87kg0714rhx3g2w22asg";
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
