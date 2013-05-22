{ cabal }:

cabal.mkDerivation (self: {
  pname = "syb";
  version = "0.3.6.2";
  sha256 = "0n1h0zlq2ygwkh7s914gfy4rg4b5kg6msd65id84c5412sri3mk4";
  meta = {
    homepage = "http://www.cs.uu.nl/wiki/GenericProgramming/SYB";
    description = "Scrap Your Boilerplate";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
