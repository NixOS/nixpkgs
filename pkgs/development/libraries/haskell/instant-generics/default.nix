{ cabal, syb }:

cabal.mkDerivation (self: {
  pname = "instant-generics";
  version = "0.3.3";
  sha256 = "125ninsm1k9hixlwqdn7b842fpqxz4zih4rh8fn7r7djmv1zpq9q";
  buildDepends = [ syb ];
  noHaddock = true;
  meta = {
    homepage = "http://www.cs.uu.nl/wiki/GenericProgramming/InstantGenerics";
    description = "Generic programming library with a sum of products view";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
