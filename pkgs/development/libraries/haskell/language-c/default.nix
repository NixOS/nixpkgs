{ cabal, alex, filepath, happy, syb }:

cabal.mkDerivation (self: {
  pname = "language-c";
  version = "0.4.3";
  sha256 = "0y5yn0jaairqixxqx7c80z5y5mc6czshps7wghjci1s39mn9cjf6";
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
