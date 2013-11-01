{ cabal, text }:

cabal.mkDerivation (self: {
  pname = "blaze-builder";
  version = "0.3.2.0";
  sha256 = "169q318jxhk7rmb8r679zhcdcmcca87d55341cnzajmc0580n6ih";
  buildDepends = [ text ];
  meta = {
    homepage = "http://github.com/meiersi/blaze-builder";
    description = "Efficient buffered output";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
