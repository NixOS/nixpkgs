{ cabal, llvm, repa, vector }:

cabal.mkDerivation (self: {
  pname = "repa-algorithms";
  version = "3.2.3.1";
  sha256 = "12w76npa52g7zxa0j9w8q9njacm2dn0hcd8a8386p9r6iy6lpjwc";
  buildDepends = [ repa vector ];
  extraLibraries = [ llvm ];
  jailbreak = true;
  meta = {
    homepage = "http://repa.ouroborus.net";
    description = "Algorithms using the Repa array library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
