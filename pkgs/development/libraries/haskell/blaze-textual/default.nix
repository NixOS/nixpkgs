{ cabal, blazeBuilder, text, time, vector }:

cabal.mkDerivation (self: {
  pname = "blaze-textual";
  version = "0.2.0.6";
  sha256 = "1699fj9zig6ids9bdjn5v0gqhnyx5dkzi542gkx1gs8943c94737";
  buildDepends = [ blazeBuilder text time vector ];
  meta = {
    homepage = "http://github.com/bos/blaze-textual";
    description = "Fast rendering of common datatypes";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
