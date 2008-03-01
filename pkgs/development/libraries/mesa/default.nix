{stdenv, fetchurl, pkgconfig, x11, xlibs, libdrm}:

let

  target =
    if stdenv.system == "i686-linux" then "linux-dri-x86" else
    if stdenv.system == "x86_64-linux" then "linux-dri-x86-64" else
    abort "unsupported platform for Mesa"; # !!! change to throw, remove all the mesa asserts in all-packages.nix

  # Missing file in 7.0.2. Can be removed for >= 7.0.3.
  missingPC = fetchurl {
    url = "http://sources.gentoo.org/viewcvs.py/*checkout*/gentoo-x86/media-libs/mesa/files/7.0.2-glw.pc.in?rev=1.1";
    sha256 = "1z4d50pllwi8g6n567dk3zxq4qmam79n72wr55mdqx0jrdj4fj0v";
  };
    
in

stdenv.mkDerivation {
  name = "mesa-7.0.2";
  
  src = fetchurl {
    url = mirror://sourceforge/mesa3d/MesaLib-7.0.2.tar.bz2;
    md5 = "93e6ed7924ff069a4f883b4fce5349dc";
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
    cp ${missingPC} src/glw/glw.pc.in
  ";
  
  buildInputs = [
    pkgconfig x11 xlibs.makedepend libdrm xlibs.glproto xlibs.libXmu
    xlibs.libXi xlibs.libXxf86vm xlibs.libXfixes xlibs.libXdamage
  ];
  
  passthru = {inherit libdrm;};
  
  meta = {
    description = "An open source implementation of OpenGL";
    homepage = http://www.mesa3d.org/;
  };
}
