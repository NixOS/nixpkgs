{ cabal, blazeBuilder, deepseq, filepath, mtl, parsec, syb
, sybWithClass, text, time, utf8String
}:

cabal.mkDerivation (self: {
  pname = "HStringTemplate";
  version = "0.6.12";
  sha256 = "02jx02qbs4jxpf1s8nzc9lbaz0flkfcy6xj475v77i45xc1hc71p";
  buildDepends = [
    blazeBuilder deepseq filepath mtl parsec syb sybWithClass text time
    utf8String
  ];
  meta = {
    description = "StringTemplate implementation in Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
