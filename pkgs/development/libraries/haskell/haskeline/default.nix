{ cabal, extensibleExceptions, mtl, terminfo, utf8String }:

cabal.mkDerivation (self: {
  pname = "haskeline";
  version = "0.6.4.5";
  sha256 = "1blhbh53p6di3q3gldzmg3i8f4w3ahipai3di49i4rdcnjry0j5b";
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
