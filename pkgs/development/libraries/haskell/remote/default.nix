{ cabal, binary, filepath, mtl, network, pureMD5, stm, syb, time
, utf8String
}:

cabal.mkDerivation (self: {
  pname = "remote";
  version = "0.1.1";
  sha256 = "14awzhpc21pp4iq53vz4ib81ygxsnlnfppv723zy77z6jja08gf0";
  buildDepends = [
    binary filepath mtl network pureMD5 stm syb time utf8String
  ];
  meta = {
    description = "Cloud Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
