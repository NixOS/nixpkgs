{ cabal, blazeBuilder, httpTypes, mtl, network, parsec, text
, utf8String
}:

cabal.mkDerivation (self: {
  pname = "web-routes";
  version = "0.26.2";
  sha256 = "0v7vkd53jf9zf2m0lbiq10qp39ghlnxwafs1hixbz2qfcgsns10j";
  buildDepends = [
    blazeBuilder httpTypes mtl network parsec text utf8String
  ];
  meta = {
    description = "Library for maintaining correctness and composability of URLs within an application";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
