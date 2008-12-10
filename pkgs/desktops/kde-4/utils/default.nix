args: with args;

stdenv.mkDerivation {
  name = "kdeutils-4.0.0";

  src = fetchurl {
    url = mirror://kde/stable/4.0.0/src/kdeutils-4.0.0.tar.bz2;
    md5 = "5815625f215ff3be47a21074d2c047a0";
  };

  buildInputs = [kdelibs kdepimlibs kdeworkspace gmp libzip python ];
# TODO : tpctl
}
