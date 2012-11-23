{ cabal, syb }:

cabal.mkDerivation (self: {
  pname = "instant-generics";
  version = "0.3.7";
  sha256 = "0kkfx009ij3pwga7x18vr8p0ffhahlp8sb6ykzfh8rhcqd4ryzyv";
  buildDepends = [ syb ];
  meta = {
    homepage = "http://www.cs.uu.nl/wiki/GenericProgramming/InstantGenerics";
    description = "Generic programming library with a sum of products view";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
