{ cabal }:

cabal.mkDerivation (self: {
  pname = "HUnit";
  version = "1.2.2.3";
  sha256 = "158i6s014ybh5bflzspd21qzdlhdyk89yqpmk8kwc59lxjvvjsxz";
  isLibrary = true;
  isExecutable = true;
  meta = {
    homepage = "http://hunit.sourceforge.net/";
    description = "A unit testing framework for Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
