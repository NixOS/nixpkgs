{ cabal, text }:

cabal.mkDerivation (self: {
  pname = "xml-types";
  version = "0.3.3";
  sha256 = "0jvchgzmqsnc0dax73nh7wa7x6n07qnl4wr1d58v21rlbqcklgcn";
  buildDepends = [ text ];
  meta = {
    homepage = "https://john-millikin.com/software/haskell-xml/";
    description = "Basic types for representing XML";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
