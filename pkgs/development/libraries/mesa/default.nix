{ stdenv, fetchurl, pkgconfig, x11, xlibs, libdrm, expat, lipo ? null, talloc }:

if ! stdenv.lib.lists.elem stdenv.system stdenv.lib.platforms.mesaPlatforms then
  throw "unsupported platform for Mesa"
else

let version = "7.10.1"; in

stdenv.mkDerivation {
  name = "mesa-${version}";

  src = fetchurl {
    url = "ftp://ftp.freedesktop.org/pub/mesa/${version}/MesaLib-${version}.tar.bz2";
    md5 = "efe8da4d80c2a5d32a800770b8ce5dfa";
  };

  patches = [ ./swrast-settexbuffer.patch ];

  configureFlags =
    "--disable-gallium"
    + stdenv.lib.optionalString (stdenv.system == "mips64-linux")
      " --with-dri-drivers=swrast --with-driver=dri"
    + stdenv.lib.optionalString stdenv.isDarwin " --disable-egl";

  buildInputs =
    [ pkgconfig expat x11 libdrm xlibs.makedepend xlibs.glproto
      xlibs.libXxf86vm xlibs.libXfixes xlibs.libXdamage xlibs.dri2proto
      lipo talloc 
    ];

  enableParallelBuilding = true;

  passthru = { inherit libdrm; };

  meta = {
    description = "An open source implementation of OpenGL";
    homepage = http://www.mesa3d.org/;
    license = "bsd";
  };
}
