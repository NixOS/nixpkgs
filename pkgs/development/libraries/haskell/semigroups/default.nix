{ cabal }:

cabal.mkDerivation (self: {
  pname = "semigroups";
  version = "0.8.2";
  sha256 = "1vxavkpg68qfs5arhi76liafds1jd8prircnp66ykhkj40z5aix0";
  meta = {
    homepage = "http://github.com/ekmett/semigroups/";
    description = "Haskell 98 semigroups";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
