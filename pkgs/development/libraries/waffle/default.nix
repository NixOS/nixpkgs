{ stdenv, lib, fetchurl, cmake, libX11, mesa, pkgconfig, udev }:

stdenv.mkDerivation rec {
  name = "waffle-${version}";
  version = "1.5.1";

  src = fetchurl {
    url = "http://www.waffle-gl.org/files/release/waffle-${version}/waffle-${version}.tar.xz";
    sha256 = "1ai0zqmrpma0zdcpdl20bxz30cxy0jpsb2ghif0lw1hmcn90xayb";
  };

  buildInputs = [ cmake libX11 mesa pkgconfig udev ];

  # TODO: More API's can be specified here, but I've only tested GLX for now
  cmakeFlags = "-Dwaffle_has_glx=1";

  meta = with lib; {
    description = "Library for selecting an OpenGL API and window system at runtime";
    homepage    = http://www.waffle-gl.org/;
    license     = licenses.bsd2;
    maintainers = with maintainers; [ auntie ];
    platforms   = platforms.linux;
  };
}
