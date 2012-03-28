{ cabal, mtl }:

cabal.mkDerivation (self: {
  pname = "fgl";
  version = "5.4.2.3";
  sha256 = "1f46siqqv8bc9v8nxr72nxabpzfax117ncgdvif6rax5ansl48g7";
  buildDepends = [ mtl ];
  meta = {
    homepage = "http://web.engr.oregonstate.edu/~erwig/fgl/haskell";
    description = "Martin Erwig's Functional Graph Library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
