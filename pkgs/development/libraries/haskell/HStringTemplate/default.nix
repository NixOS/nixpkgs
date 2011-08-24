{ cabal, deepseq, mtl, parsec, syb, sybWithClass, text, time
, utf8String
}:

cabal.mkDerivation (self: {
  pname = "HStringTemplate";
  version = "0.6.6";
  sha256 = "1ian79az5q6m08pwb5fks52ffs4h2mq02kkcwmr6jb7i0ha2k2si";
  buildDepends = [
    deepseq mtl parsec syb sybWithClass text time utf8String
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
