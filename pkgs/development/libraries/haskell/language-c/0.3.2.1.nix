{ cabal, alex, filepath, happy, syb }:

cabal.mkDerivation (self: {
  pname = "language-c";
  version = "0.3.2.1";
  sha256 = "1qk86p88p2jk1cbgl8p5g19ip3nh6z22ddj5jac58r5ny076iimx";
  buildDepends = [ filepath syb ];
  buildTools = [ alex happy ];
  meta = {
    homepage = "http://www.sivity.net/projects/language.c/";
    description = "Analysis and generation of C code";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
