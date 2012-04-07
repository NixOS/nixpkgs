{ cabal, llvm, repa, vector }:

cabal.mkDerivation (self: {
  pname = "repa-algorithms";
  version = "3.1.0.1";
  sha256 = "17479hp6x02vdwbn201gvxrqsc6smp5q1ip61qbfsvirjih8f3pz";
  buildDepends = [ repa vector ];
  extraLibraries = [ llvm ];
  meta = {
    homepage = "http://repa.ouroborus.net";
    description = "Algorithms using the Repa array library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
