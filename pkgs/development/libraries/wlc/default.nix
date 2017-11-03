{ stdenv, fetchFromGitHub, fetchpatch, cmake, pkgconfig
, wayland, pixman, libxkbcommon, libinput, xcbutilwm, xcbutilimage, mesa_noglu
, libX11, dbus_libs, wayland-protocols
, libpthreadstubs, libXdmcp, libXext
, withOptionalPackages ? true, zlib, valgrind, doxygen
}:

let
  # for 0.0.10
  xwaylandPatch = fetchpatch {
    url = "https://github.com/Cloudef/wlc/commit/a130f6006560fb8ac02fb59a90ced1659563f9ca.diff";
    sha256 = "0kzcbqklcyg8bganm65di8cif6dpc8bkrsvkjia09kr92lymxm2c";
  };
in stdenv.mkDerivation rec {
  name = "wlc-${version}";
  version = "0.0.10";

  src = fetchFromGitHub {
    owner = "Cloudef";
    repo = "wlc";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "09kvwhrpgkxlagn9lgqxc80jbg56djn29a6z0n6h0dsm90ysyb2k";
  };

  patches = [
    xwaylandPatch
  ];

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [
    wayland pixman libxkbcommon libinput xcbutilwm xcbutilimage mesa_noglu
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
