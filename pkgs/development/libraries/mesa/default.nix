{ stdenv, fetchurl, flex, bison, pkgconfig, x11, xlibs, libdrm, file, expat
, python, libxml2Python, lipo ? null }:

if ! stdenv.lib.lists.elem stdenv.system stdenv.lib.platforms.mesaPlatforms then
  throw "unsupported platform for Mesa"
else

let version = "7.10.3"; in

stdenv.mkDerivation {
  name = "mesa-${version}";

  src = fetchurl {
    url = "ftp://ftp.freedesktop.org/pub/mesa/${version}/MesaLib-${version}.tar.bz2";
    sha256 = "1h451vgsfsp0h0wig66spqgxmjalsy28gvd9viynfwmq7741yw0y";
  };

  patches = [ ./swrast-settexbuffer.patch ];

  postPatch = ''
    find . -name "*.py" -exec sed -i -e "s|#! */usr/bin/env python|#! ${python}/bin/python|" {} +
  '';

  configureFlags =
      " --with-driver=dri --enable-gl-osmesa --enable-gles1"
    + " --enable-gallium --enable-gallium-r600 --enable-gles2"
    + " --enable-gallium-swrast --enable-gallium-egl --disable-glx-tls"
    + " --enable-xcb --enable-egl --disable-glut";

  buildInputs =
    [ pkgconfig expat x11 libdrm xlibs.makedepend xlibs.glproto
      xlibs.libXxf86vm xlibs.libXfixes xlibs.libXdamage xlibs.dri2proto
      lipo file python libxml2Python flex bison
    ];

  enableParallelBuilding = true;

  passthru = { inherit libdrm; };

  meta = {
    description = "An open source implementation of OpenGL";
    homepage = http://www.mesa3d.org/;
    license = "bsd";

    platforms = stdenv.lib.platforms.mesaPlatforms;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
