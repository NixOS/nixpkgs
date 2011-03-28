{cabal, binary, mtl, utf8String, zlib, digest}:

cabal.mkDerivation (self : {
  pname = "zip-archive";
  version = "0.1.1.7";
  sha256 = "1q52v18kl1j049kk3yb7rp0k27p6q7r72mg1vcbdid6qd7a9dh48";
  propagatedBuildInputs = [binary mtl utf8String zlib digest];
  meta = {
    description = "Library for creating and modifying zip archives";
  };
})

