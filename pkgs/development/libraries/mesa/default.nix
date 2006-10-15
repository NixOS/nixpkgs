{stdenv, fetchurl, x11, libXmu, libXi}:

assert stdenv.system == "i686-linux";

stdenv.mkDerivation {
  name = "mesa-6.4.2";
  srcs = [
    (fetchurl {
      url = http://surfnet.dl.sourceforge.net/sourceforge/mesa3d/MesaLib-6.4.2.tar.bz2;
      md5 = "7674d2c603b5834259e4e5a820cefd5b";
    })
/*    (fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/MesaGLUT-6.4.tar.bz2;
      md5 = "1a8c4d4fc699233f5fdb902b8753099e";
    })
    (fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/MesaDemos-6.4.tar.bz2;
      md5 = "1a8c4d4fc699233f5fdb902b8753099e";
    }) */
  ];
  builder = ./builder.sh;
  buildInputs = [x11 libXmu libXi];
}
