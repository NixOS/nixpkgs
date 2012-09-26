{ cabal, syb }:

cabal.mkDerivation (self: {
  pname = "instant-generics";
  version = "0.3.6";
  sha256 = "0rwxj30p4s8imwfsrrrb26dvxax74cr77yzrm5s9yj7hc7hr0c5p";
  buildDepends = [ syb ];
  meta = {
    homepage = "http://www.cs.uu.nl/wiki/GenericProgramming/InstantGenerics";
    description = "Generic programming library with a sum of products view";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
