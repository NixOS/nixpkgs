{stdenv, fetchurl, pkgconfig, x11, xlibs, libdrm}:

let

  target =
    if stdenv.system == "i686-linux" then "linux-dri-x86" else
    if stdenv.system == "x86_64-linux" then "linux-dri-x86-64" else
    abort "unsupported platform for Mesa"; # !!! change to throw, remove all the mesa asserts in all-packages.nix

in

stdenv.mkDerivation {
  name = "mesa-7.0.1";
  
  src = fetchurl {
    url = mirror://sourceforge/mesa3d/MesaLib-7.0.1.tar.bz2;
    md5 = "c056abd763e899114bf745c9eedbf9ad";
  };
/*    (fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/MesaGLUT-6.4.tar.bz2;
      md5 = "1a8c4d4fc699233f5fdb902b8753099e";
    })
    (fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/MesaDemos-6.4.tar.bz2;
      md5 = "1a8c4d4fc699233f5fdb902b8753099e";
    }) */
  
  buildFlags = "${target}";
  
  preBuild = "
    makeFlagsArray=(INSTALL_DIR=$out DRI_DRIVER_INSTALL_DIR=$out/lib/modules/dri SHELL=$SHELL)
  ";
  
  buildInputs = [
    pkgconfig x11 xlibs.makedepend libdrm xlibs.glproto xlibs.libXmu
    xlibs.libXi xlibs.libXxf86vm xlibs.libXfixes xlibs.libXdamage
  ];
  
  passthru = {inherit libdrm;};
  
  meta = {
    description = "OpenGL-compatible 3D library. Supports acceleration.";
    homepage = http://www.mesa3d.org/;
  };
}
