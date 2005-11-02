{stdenv, fetchurl, xlibs}:

assert stdenv.system == "i686-linux";

stdenv.mkDerivation {
  name = "mesa-6.4";
  srcs = [
    (fetchurl {
      url = http://surfnet.dl.sourceforge.net/sourceforge/mesa3d/MesaLib-6.4.tar.bz2;
      md5 = "85a84e47a3f718f752f306b9e0954ef6";
    })
/*    (fetchurl {
      url = http://surfnet.dl.sourceforge.net/sourceforge/mesa3d/MesaGLUT-6.4.tar.bz2;
      md5 = "1a8c4d4fc699233f5fdb902b8753099e";
    })
    (fetchurl {
      url = http://surfnet.dl.sourceforge.net/sourceforge/mesa3d/MesaDemos-6.4.tar.bz2;
      md5 = "1a8c4d4fc699233f5fdb902b8753099e";
    }) */
  ];
  builder = ./builder.sh;
  buildInputs = [xlibs.xlibs xlibs.libXmu xlibs.libXi];
}
