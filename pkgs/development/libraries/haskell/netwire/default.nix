{ cabal, deepseq, parallel, random, semigroups, time, transformers
}:

cabal.mkDerivation (self: {
  pname = "netwire";
  version = "5.0.0";
  sha256 = "1wxrckc8i86xiiyk8msa6qrhfjx4h34ry1nxh9rdcd5cy03kalks";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    deepseq parallel random semigroups time transformers
  ];
  meta = {
    description = "Functional reactive programming library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
