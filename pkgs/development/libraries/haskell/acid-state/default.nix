{ cabal, cereal, extensibleExceptions, filepath, mtl, network
, safecopy, stm
}:

cabal.mkDerivation (self: {
  pname = "acid-state";
  version = "0.12.0";
  sha256 = "0gz66j0091k18yy81kn3vcadjg8lrqdfxibjbzwyhi64m894f13w";
  buildDepends = [
    cereal extensibleExceptions filepath mtl network safecopy stm
  ];
  meta = {
    homepage = "http://acid-state.seize.it/";
    description = "Add ACID guarantees to any serializable Haskell data structure";
    license = self.stdenv.lib.licenses.publicDomain;
    platforms = self.ghc.meta.platforms;
  };
})
