{ cabal, llvm, repa, vector }:

cabal.mkDerivation (self: {
  pname = "repa-algorithms";
  version = "3.2.4.1";
  sha256 = "0xb2r726z73ghiqik39n99q5hal16y7ydk16q2rbycbvc37yq24b";
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
