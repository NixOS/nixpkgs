{ cabal, semigroups, unorderedContainers }:

cabal.mkDerivation (self: {
  pname = "charset";
  version = "0.3.5";
  sha256 = "0842jdqg7hipgkvax3p4cb2y3znsgcmbj9nfrg2448dg2nanlhsn";
  buildDepends = [ semigroups unorderedContainers ];
  meta = {
    homepage = "http://github.com/ekmett/charset";
    description = "Fast unicode character sets based on complemented PATRICIA tries";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
