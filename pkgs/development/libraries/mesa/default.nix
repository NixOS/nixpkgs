{ stdenv, fetchurl, pkgconfig, x11, xlibs, libdrm, expat, lipo ? null }:

if ! stdenv.lib.lists.elem stdenv.system stdenv.lib.platforms.mesaPlatforms then
  throw "unsupported platform for Mesa"
else

stdenv.mkDerivation {
  name = "mesa-7.8.2";

  src = fetchurl {
    url = ftp://ftp.freedesktop.org/pub/mesa/7.8.2/MesaLib-7.8.2.tar.bz2;
    md5 = "6be2d343a0089bfd395ce02aaf8adb57";
  };

  configureFlags =
    "--disable-gallium"
    + (if stdenv.system == "ict_loongson-2_v0.3_fpu_v0.1-linux" then
      " --with-dri-drivers=swrast --with-driver=dri" else "")
    + (if stdenv.isDarwin then " --disable-egl" else "");

  buildInputs =
    [ pkgconfig expat x11 libdrm xlibs.glproto
      xlibs.libXxf86vm xlibs.libXfixes xlibs.libXdamage xlibs.dri2proto
      lipo
    ];

  passthru = { inherit libdrm; };

  meta = {
    description = "An open source implementation of OpenGL";
    homepage = http://www.mesa3d.org/;
    license = "bsd";
  };
}
