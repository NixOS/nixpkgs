{ cabal, deepseq, mtl, parallel, time }:

cabal.mkDerivation (self: {
  pname = "data-pprint";
  version = "0.2.3";
  sha256 = "1ygbhn399d4hlrdjmg7gxbr5akydb78p6qa80rv7m6j0fsqzbf6y";
  buildDepends = [ deepseq mtl parallel time ];
  jailbreak = true;
  meta = {
    description = "Prettyprint and compare Data values";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
