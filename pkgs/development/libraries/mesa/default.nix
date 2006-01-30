{stdenv, fetchurl, x11, libXmu, libXi}:

assert stdenv.system == "i686-linux";

stdenv.mkDerivation {
  name = "mesa-6.4";
  srcs = [
    (fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/MesaLib-6.4.tar.bz2;
      md5 = "85a84e47a3f718f752f306b9e0954ef6";
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
