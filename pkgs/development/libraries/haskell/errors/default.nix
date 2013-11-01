{ cabal, either, safe, transformers }:

cabal.mkDerivation (self: {
  pname = "errors";
  version = "1.4.3";
  sha256 = "02xvfh0kfca7z5vhnkmqg5gw5i5ad5bc3jf8flxj75ry7wqggfmm";
  buildDepends = [ either safe transformers ];
  jailbreak = true;
  meta = {
    description = "Simplified error-handling";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
