{ stdenv, fetchurl, pkgconfig, x11, xlibs, libdrm, expat }:

if ! stdenv.lib.lists.elem stdenv.system stdenv.lib.platforms.mesaPlatforms then
  throw "unsupported platform for Mesa"
else

stdenv.mkDerivation {
  name = "mesa-7.6.1";
  
  src = fetchurl {
    url = ftp://ftp.freedesktop.org/pub/mesa/7.6.1/MesaLib-7.6.1.tar.bz2;
    md5 = "7db4617e9e10ad3aca1b64339fd71b7d";
  };

  configureFlags = "--disable-gallium";
  
  buildInputs =
    [ pkgconfig expat x11 libdrm xlibs.glproto
      xlibs.libXxf86vm xlibs.libXfixes xlibs.libXdamage xlibs.dri2proto
    ];
  
  passthru = { inherit libdrm; };
  
  meta = {
    description = "An open source implementation of OpenGL";
    homepage = http://www.mesa3d.org/;
    license = "bsd";
  };
}
