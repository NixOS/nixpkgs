{stdenv, fetchurl, xlibs}:

assert stdenv.system == "i686-linux";

stdenv.mkDerivation {
  name = "mesa-6.0.1";
  srcs = [
    (fetchurl {
      url = http://heanet.dl.sourceforge.net/sourceforge/mesa3d/MesaLib-6.0.1.tar.bz2;
      md5 = "b7f14088c5c2f14490d2739a91102112";
    })
    (fetchurl {
      url = http://heanet.dl.sourceforge.net/sourceforge/mesa3d/MesaDemos-6.0.1.tar.bz2;
      md5 = "dd6aadfd9ca8e1cfa90c6ee492bc6f43";
    })
  ];
  builder = ./builder.sh;
  buildInputs = [xlibs.xlibs xlibs.libXmu xlibs.libXi];
}
