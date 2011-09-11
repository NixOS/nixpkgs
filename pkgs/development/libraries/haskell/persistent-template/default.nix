{ cabal, monadControl, persistent, text }:

cabal.mkDerivation (self: {
  pname = "persistent-template";
  version = "0.6.2";
  sha256 = "1gnqryn701b97fwzjhkk4x4k7p1w5w8cdn5x9hz8sb68vkgrplfx";
  buildDepends = [ monadControl persistent text ];
  meta = {
    homepage = "http://www.yesodweb.com/book/persistent";
    description = "Type-safe, non-relational, multi-backend persistence";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
