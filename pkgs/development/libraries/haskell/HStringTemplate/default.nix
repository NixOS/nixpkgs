{ cabal, Cabal, deepseq, filepath, mtl, parsec, syb, sybWithClass
, text, time, utf8String
}:

cabal.mkDerivation (self: {
  pname = "HStringTemplate";
  version = "0.6.8";
  sha256 = "1fybvb3v2b786n1hfzcvyanj3yfm5j8z4fm48vaskcggawh6rlkr";
  buildDepends = [
    Cabal deepseq filepath mtl parsec syb sybWithClass text time
    utf8String
  ];
  meta = {
    description = "StringTemplate implementation in Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
