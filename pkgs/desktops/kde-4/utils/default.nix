args: with args;

stdenv.mkDerivation {
  name = "kdeutils-4.0.0";
  
  src = fetchurl {
    url = mirror://kde/stable/4.0/src/kdeutils-4.0.0.tar.bz2;
    sha256 = "0ha31z79ikkbknhyklihzys0w4jfz4qx8jiyja0gwh428f7mxqj4";
  };

  buildInputs = [kdelibs kdepimlibs kdeworkspace gmp libzip python ];
# TODO : tpctl
  patchPhase="fixCmakeDbusCalls";
}
