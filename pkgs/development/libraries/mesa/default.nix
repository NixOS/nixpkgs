{stdenv, fetchurl, pkgconfig, x11, xlibs, libdrm, expat}:

let

  target =
    if stdenv.system == "i686-linux" then "linux-dri-x86" else
    if stdenv.system == "x86_64-linux" then "linux-dri-x86-64" else
    abort "unsupported platform for Mesa"; # !!! change to throw, remove all the mesa asserts in all-packages.nix

in

stdenv.mkDerivation {
  name = "mesa-7.2";
  
  src = fetchurl {
    url = mirror://sourceforge/mesa3d/MesaLib-7.2.tar.bz2;
    md5 = "04d379292e023df0b0266825cb0dbde5";
  };
  
  buildInputs = [
    pkgconfig expat x11 libdrm xlibs.glproto
    xlibs.libXxf86vm xlibs.libXfixes xlibs.libXdamage
  ];
  
  passthru = {inherit libdrm;};
  
  meta = {
    description = "An open source implementation of OpenGL";
    homepage = http://www.mesa3d.org/;
  };
}
