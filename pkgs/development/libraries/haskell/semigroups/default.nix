{ cabal }:

cabal.mkDerivation (self: {
  pname = "semigroups";
  version = "0.8.0.1";
  sha256 = "0z2pmfqk75qpjv720l06237cjdn8nmcchzyq7rp4wcvgdik8ahin";
  meta = {
    homepage = "http://github.com/ekmett/semigroups/";
    description = "Haskell 98 semigroups";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
