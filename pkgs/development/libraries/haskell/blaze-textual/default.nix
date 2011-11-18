{ cabal, blazeBuilder, text, time, vector }:

cabal.mkDerivation (self: {
  pname = "blaze-textual";
  version = "0.2.0.5";
  sha256 = "0rl41idjmrw227yi2x6nk2rlm93rgzz2y7jvz2yvmya2ihrppzjf";
  buildDepends = [ blazeBuilder text time vector ];
  meta = {
    homepage = "http://github.com/bos/blaze-textual";
    description = "Fast rendering of common datatypes";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
