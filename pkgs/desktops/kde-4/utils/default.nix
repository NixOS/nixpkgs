args: with args;

stdenv.mkDerivation {
  name = "kdeutils-4.0beta4";
  
  src = fetchurl {
    url = mirror://kde/unstable/3.95/src/kdeutils-3.95.0.tar.bz2;
    sha256 = "1b8jvdy83qwhnfwqxzx96bxnaxss25psazifymyb0z4ynkqmadlh";
  };

  buildInputs = [kdelibs kdepimlibs kdeworkspace gmp libzip python ];
# TODO : tpctl
}
