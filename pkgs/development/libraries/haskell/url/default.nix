{ cabal, utf8String }:

cabal.mkDerivation (self: {
  pname = "url";
  version = "2.1.2";
  sha256 = "2cf5c4296418afe3940ae4de66d867897b1382cc4d37a0b9a5ccffa16743ef91";
  buildDepends = [ utf8String ];
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/Url";
    description = "A library for working with URLs";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
