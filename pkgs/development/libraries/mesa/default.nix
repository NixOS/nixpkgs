{ stdenv, fetchurl, pkgconfig, x11, xlibs, libdrm, expat }:

if stdenv.system != "i686-linux" && stdenv.system != "x86_64-linux" && stdenv.system != "i686-darwin" && stdenv.system != "i686-freebsd" then
  throw "unsupported platform for Mesa"
else

stdenv.mkDerivation {
  name = "mesa-7.5.2";
  
  src = fetchurl {
    url = ftp://ftp.freedesktop.org/pub/mesa/7.5.2/MesaLib-7.5.2.tar.bz2;
    md5 = "94e47a499f1226803869c2e37a6a8e3a";
  };
  
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
