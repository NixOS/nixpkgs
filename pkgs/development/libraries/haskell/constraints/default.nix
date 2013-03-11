{ cabal, newtype }:

cabal.mkDerivation (self: {
  pname = "constraints";
  version = "0.3.2";
  sha256 = "1fmjl6dh2iswvmq8r3izplp6zg9m8yq1c4rj0zpqjbv2iqsi4kl1";
  buildDepends = [ newtype ];
  meta = {
    homepage = "http://github.com/ekmett/constraints/";
    description = "Constraint manipulation";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
