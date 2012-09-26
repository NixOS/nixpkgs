{ cabal, blazeBuilder, deepseq, filepath, mtl, parsec, syb
, sybWithClass, text, time, utf8String
}:

cabal.mkDerivation (self: {
  pname = "HStringTemplate";
  version = "0.6.10";
  sha256 = "0asv8n4l2j819cngxgdk5p0b4bqcxnmdc2mlp9b3s7mrs15ljxkk";
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
