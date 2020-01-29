{ stdenv, fetchurl, pkgconfig, libGLU, epoxy, libX11, libdrm, mesa }:


stdenv.mkDerivation rec {

  pname = "virglrenderer";
  version = "0.7.0";

  src = fetchurl {
    url = "https://www.freedesktop.org/software/virgl/${pname}-${version}.tar.bz2";
    sha256 = "041agg1d6i8hg250y30f08n3via0hs9rbijxdrfifb8ara805v0m";
  };

  buildInputs = [ libGLU epoxy libX11 libdrm mesa ];

  nativeBuildInputs = [ pkgconfig ];

  # Fix use of fd_set without proper include
  prePatch = ''
    sed -e '1i#include <sys/select.h>' -i vtest/util.c
  '';

  meta = with stdenv.lib; {
    description = "A virtual 3D GPU library that allows a qemu guest to use the host GPU for accelerated 3D rendering";
    homepage = https://virgil3d.github.io/;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.xeji ];
  };

}
