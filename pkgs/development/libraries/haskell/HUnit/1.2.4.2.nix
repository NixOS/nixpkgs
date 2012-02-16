{ cabal }:

cabal.mkDerivation (self: {
  pname = "HUnit";
  version = "1.2.4.2";
  sha256 = "0yijvrjmmz6vvgi5h1195z4psmymvhq6rr7kkd26nqbd34lbrg7x";
  isLibrary = true;
  isExecutable = true;
  meta = {
    homepage = "http://hunit.sourceforge.net/";
    description = "A unit testing framework for Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
