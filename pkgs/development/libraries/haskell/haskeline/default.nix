{ cabal, extensibleExceptions, mtl, terminfo, utf8String }:

cabal.mkDerivation (self: {
  pname = "haskeline";
  version = "0.6.4.4";
  sha256 = "03cnhidnpnz7fh34c7x0rpl15zi6hkh9khganrdhwa59srxzbxqb";
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
