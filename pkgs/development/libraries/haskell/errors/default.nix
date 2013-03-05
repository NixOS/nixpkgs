{ cabal, either, safe, transformers }:

cabal.mkDerivation (self: {
  pname = "errors";
  version = "1.4.1";
  sha256 = "18npfwr6byh0aib9qxpynr2gf0v92c0xbxky4a733jbdrwli5c40";
  buildDepends = [ either safe transformers ];
  meta = {
    description = "Simplified error-handling";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
