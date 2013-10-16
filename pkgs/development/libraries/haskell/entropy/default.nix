{ cabal }:

cabal.mkDerivation (self: {
  pname = "entropy";
  version = "0.2.2.4";
  sha256 = "1cjmpb0rh1ib4j9mwmf1irn401vmjawxkshxdmmb4643rmcgx1gm";
  meta = {
    homepage = "https://github.com/TomMD/entropy";
    description = "A platform independent entropy source";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
