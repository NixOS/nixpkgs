{ cabal, syb }:

cabal.mkDerivation (self: {
  pname = "instant-generics";
  version = "0.3.4";
  sha256 = "0j3sfbw3j0izwmhvwcl8nxxvlrpfla5rngxx2yvl6w5i87wyhswi";
  buildDepends = [ syb ];
  noHaddock = true;
  meta = {
    homepage = "http://www.cs.uu.nl/wiki/GenericProgramming/InstantGenerics";
    description = "Generic programming library with a sum of products view";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
