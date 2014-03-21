{ cabal, errorcallEqInstance, hspec, setenv }:

cabal.mkDerivation (self: {
  pname = "base-compat";
  version = "0.4.2";
  sha256 = "0rcra6bgx955c2yd52y6v7lmlm5r86sdmii3qapx6yghqhdslzry";
  buildDepends = [ errorcallEqInstance setenv ];
  testDepends = [ hspec setenv ];
  meta = {
    description = "A compatibility layer for base";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
