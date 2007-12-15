args: with args;

stdenv.mkDerivation {
  name = "kdeutils-4.0rc2";
  
  src = fetchurl {
    url = mirror://kde/unstable/3.97/src/kdeutils-3.97.0.tar.bz2;
    sha256 = "0nhs91xf83xyf4wlpppavrhyi76qdnilhaynwjirx5n85hjl4iiq";
  };

  buildInputs = [kdelibs kdepimlibs kdeworkspace gmp libzip python ];
# TODO : tpctl
  patchPhase="fixCmakeDbusCalls";
}
