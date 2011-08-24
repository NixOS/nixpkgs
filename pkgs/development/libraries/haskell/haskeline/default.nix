{ cabal, extensibleExceptions, mtl, terminfo, utf8String }:

cabal.mkDerivation (self: {
  pname = "haskeline";
  version = "0.6.4.3";
  sha256 = "1dlrsazprvn6xcd12k5ln536rv9sljjccrjgpq6jj6b9ziadwiwr";
  buildDepends = [ extensibleExceptions mtl terminfo utf8String ];
  meta = {
    homepage = "http://trac.haskell.org/haskeline";
    description = "A command-line interface for user input, written in Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
