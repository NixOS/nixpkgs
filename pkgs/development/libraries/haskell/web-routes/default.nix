{ cabal, blazeBuilder, httpTypes, mtl, network, parsec, text
, utf8String
}:

cabal.mkDerivation (self: {
  pname = "web-routes";
  version = "0.27.1";
  sha256 = "0rbl57qnn908hwfhj14m8z11pscrv44rlg7c9y9rm6jvwy4v58qz";
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
