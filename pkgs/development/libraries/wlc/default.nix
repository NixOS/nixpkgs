{ stdenv, fetchFromGitHub, fetchpatch, cmake, pkgconfig
, wayland, pixman, libxkbcommon, libinput, xcbutilwm, xcbutilimage, libGL
, libX11, dbus_libs, wayland-protocols
, libpthreadstubs, libXdmcp, libXext
, withOptionalPackages ? true, zlib, valgrind, doxygen
}:

stdenv.mkDerivation rec {
  name = "wlc-${version}";
  version = "0.0.11";

  src = fetchFromGitHub {
    owner = "Cloudef";
    repo = "wlc";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "1qnak907gjd35hq4b0rrhgb7kz5iwnirh8yk372yzxpgk7dq0gz9";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [
    wayland pixman libxkbcommon libinput xcbutilwm xcbutilimage libGL
    libX11 dbus_libs wayland-protocols
    libpthreadstubs libXdmcp libXext ]
    ++ stdenv.lib.optionals withOptionalPackages [ zlib valgrind doxygen ];

  doCheck = true;
  checkTarget = "test";
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A library for making a simple Wayland compositor";
    homepage    = https://github.com/Cloudef/wlc;
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ primeos ]; # Trying to keep it up-to-date.
  };
}
