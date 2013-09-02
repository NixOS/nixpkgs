{ cabal }:

cabal.mkDerivation (self: {
  pname = "groups";
  version = "0.3.0.0";
  sha256 = "07swv09l98fxh563w1x8n8xzgh9q7n9dbx4gx3i77kwi72vmxl8x";
  meta = {
    description = "Haskell 98 groups";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
