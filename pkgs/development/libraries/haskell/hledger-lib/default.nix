{ cabal, HUnit, mtl, parsec, regexpr, safe, split, time, utf8String
}:

cabal.mkDerivation (self: {
  pname = "hledger-lib";
  version = "0.14";
  sha256 = "9a6d6ab4383800279e135e9bbcd886e95cea45232d093202c5d43e6edd1f927c";
  buildDepends = [
    HUnit mtl parsec regexpr safe split time utf8String
  ];
  meta = {
    homepage = "http://hledger.org";
    description = "Reusable types and utilities for the hledger accounting tool and financial apps in general";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
