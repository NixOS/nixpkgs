{ stdenv, fetchFromGitHub, cmake, pkgconfig
, wayland, pixman, libxkbcommon, libinput, libxcb, xcbutilwm, xcbutilimage, mesa
, libdrm, udev, libX11, libXdamage, systemd, dbus_libs, wayland-protocols
, libpthreadstubs, libXau, libXdmcp, libXext, libXxf86vm
, withOptionalPackages ? true, zlib, valgrind, doxygen
}:

stdenv.mkDerivation rec {
  name = "wlc-${version}";
  version = "0.0.10";

  src = fetchFromGitHub {
    owner = "Cloudef";
    repo = "wlc";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "09kvwhrpgkxlagn9lgqxc80jbg56djn29a6z0n6h0dsm90ysyb2k";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [
    wayland pixman libxkbcommon libinput libxcb xcbutilwm xcbutilimage mesa
    libdrm udev libX11 libXdamage systemd dbus_libs wayland-protocols
    libpthreadstubs libXau libXdmcp libXext libXxf86vm ]
    ++ stdenv.lib.optionals withOptionalPackages [ zlib valgrind doxygen ];

  doCheck = true;
  checkTarget = "test";

  meta = with stdenv.lib; {
    description = "A library for making a simple Wayland compositor";
    homepage    = https://github.com/Cloudef/wlc;
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ primeos ]; # Trying to keep it up-to-date.
  };
}
