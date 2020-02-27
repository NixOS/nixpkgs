{ stdenv, fetchurl, cmake, meson, ninja, pkgconfig, python3
, libGLU, epoxy, libX11, libdrm, mesa
}:

stdenv.mkDerivation rec {
  pname = "virglrenderer";
  version = "0.8.1";

  src = fetchurl {
    url = "https://gitlab.freedesktop.org/virgl/virglrenderer/-/archive/virglrenderer-${version}/virglrenderer-virglrenderer-${version}.tar.bz2";
    sha256 = "0ac39mplmy6lmcd6cljmfsrfby7m6ac3dzvmnn5pv200drl415l4";
  };

  buildInputs = [ libGLU epoxy libX11 libdrm mesa ];

  nativeBuildInputs = [ cmake meson ninja pkgconfig python3 ];

  dontUseCmakeConfigure = true;

  meta = with stdenv.lib; {
    description = "A virtual 3D GPU library that allows a qemu guest to use the host GPU for accelerated 3D rendering";
    homepage = https://virgil3d.github.io/;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.xeji ];
  };
}
