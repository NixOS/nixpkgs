{ cabal }:

cabal.mkDerivation (self: {
  pname = "semigroups";
  version = "0.8.3.1";
  sha256 = "0gl2s6vd2cswb4qmkndfgnx9a747f4vhbx52lvixyq3sbgz1vain";
  meta = {
    homepage = "http://github.com/ekmett/semigroups/";
    description = "Haskell 98 semigroups";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
