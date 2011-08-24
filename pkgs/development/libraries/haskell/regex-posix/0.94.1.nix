{ cabal, regexBase }:

cabal.mkDerivation (self: {
  pname = "regex-posix";
  version = "0.94.1";
  sha256 = "63e76de0610d35f1b576ae65a25a38e04e758ed64b9b3512de95bdffd649485c";
  buildDepends = [ regexBase ];
  meta = {
    homepage = "http://sourceforge.net/projects/lazy-regex";
    description = "Replaces/Enhances Text.Regex";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
