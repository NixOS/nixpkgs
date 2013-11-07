{ cabal }:

cabal.mkDerivation (self: {
  pname = "deepseq";
  version = "1.3.0.2";
  sha256 = "09jnfz5158s4fvlfjbz44vb5jsvflagmsrgbk846arymwym6b7bp";
  meta = {
    description = "Deep evaluation of data structures";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
