{ cabal, happy, syb }:

cabal.mkDerivation (self: {
  pname = "haskell-src";
  version = "1.0.1.5";
  sha256 = "1ay3i2sbrp0pzg6fagg8gqrwq5lcnm5jb5sr11frbk274a82cdwz";
  buildDepends = [ syb ];
  buildTools = [ happy ];
  preConfigure = "runhaskell Setup.hs clean";
  meta = {
    description = "Support for manipulating Haskell source code";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
