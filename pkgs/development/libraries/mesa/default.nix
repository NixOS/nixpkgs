{ stdenv, fetchurl, pkgconfig, x11, xlibs, libdrm, file, expat, pythonFull, lipo ? null, talloc }:

if ! stdenv.lib.lists.elem stdenv.system stdenv.lib.platforms.mesaPlatforms then
  throw "unsupported platform for Mesa"
else

let version = "7.10.2"; in

stdenv.mkDerivation {
  name = "mesa-${version}";

  src = fetchurl {
    url = "ftp://ftp.freedesktop.org/pub/mesa/${version}/MesaLib-${version}.tar.bz2";
    sha256 = "1hf7f6n5ms674v3bv5c9mrcg30kbraijxacl8s031kqirrw2dvcc";
  };

  patches = [ ./swrast-settexbuffer.patch ];

  postPatch = ''
    find . -name "*.py" -exec sed -i -e "s|#! */usr/bin/env python|#! ${pythonFull}/bin/python|" {} +
  '';

  configureFlags =
    "--enable-gallium --enable-gl-osmesa --with-dri-drivers=swrast,radeon,r600 "
    + stdenv.lib.optionalString (stdenv.system == "mips64-linux")
      " --with-dri-drivers=swrast --with-driver=dri"
    + stdenv.lib.optionalString stdenv.isDarwin " --disable-egl";

  buildInputs =
    [ pkgconfig expat x11 libdrm xlibs.makedepend xlibs.glproto
      xlibs.libXxf86vm xlibs.libXfixes xlibs.libXdamage xlibs.dri2proto
      lipo talloc file pythonFull
    ];

  enableParallelBuilding = true;

  passthru = { inherit libdrm; };

  meta = {
    description = "An open source implementation of OpenGL";
    homepage = http://www.mesa3d.org/;
    license = "bsd";
  };
}
