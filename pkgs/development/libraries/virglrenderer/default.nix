{ stdenv, fetchurl, pkgconfig, libGLU, epoxy, libX11, libdrm, mesa_noglu }:


stdenv.mkDerivation rec {

  name = "virglrenderer-${version}";
  version = "0.6.0";

  src = fetchurl {
    url = "https://www.freedesktop.org/software/virgl/${name}.tar.bz2";
    sha256 = "a549e351e0eb2ad1df471386ddcf85f522e7202808d1616ee9ff894209066e1a";
  };

  buildInputs = [ libGLU epoxy libX11 libdrm mesa_noglu ];

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
