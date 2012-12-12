{ cabal, either, safe, transformers }:

cabal.mkDerivation (self: {
  pname = "errors";
  version = "1.3.1";
  sha256 = "0vfpnpkiz362bvjyaf35spfk3h6vw7xi1x3f8agzs7kmxrdvrfik";
  buildDepends = [ either safe transformers ];
  meta = {
    description = "Simplified error-handling";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
