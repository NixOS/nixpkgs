{stdenv, fetchurl, x11, libXmu, libXi}:

assert stdenv.system == "i686-linux";

stdenv.mkDerivation {
  name = "mesa-6.5.2";
  srcs = [
    (fetchurl {
      url = http://mesh.dl.sourceforge.net/sourceforge/mesa3d/MesaLib-6.5.2.tar.bz2;
      sha256 = "0pxq3zjfdgcpkc92cyzl9hskdmc8qxxp7b2smywixmb10jim0zqk";
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
