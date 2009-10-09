{stdenv, fetchurl, pkgconfig, x11, xlibs, libdrm, expat}:

if stdenv.system != "i686-linux" && stdenv.system != "x86_64-linux" && stdenv.system != "i686-darwin" && stdenv.system != "i686-freebsd" then
  throw "unsupported platform for Mesa"
else

stdenv.mkDerivation {
  name = "mesa-7.4.1";
  
  src = fetchurl {
    url = mirror://sourceforge/mesa3d/MesaLib-7.4.1.tar.bz2;
    md5 = "423260578b653818ba66c2fcbde6d7ad";
  };
  
  buildInputs = [
    pkgconfig expat x11 libdrm xlibs.glproto
    xlibs.libXxf86vm xlibs.libXfixes xlibs.libXdamage xlibs.dri2proto
  ];
  
  passthru = {inherit libdrm;};
  
  meta = {
    description = "An open source implementation of OpenGL";
    homepage = http://www.mesa3d.org/;
  };
}
