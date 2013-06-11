{ cabal, pipes }:

cabal.mkDerivation (self: {
  pname = "pipes-parse";
  version = "1.0.0";
  sha256 = "0fk39a6d0ik5ghwyj6yyi9d0cj2sp22812fin7amcxcafrplf88w";
  buildDepends = [ pipes ];
  meta = {
    description = "Parsing infrastructure for the pipes ecosystem";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
