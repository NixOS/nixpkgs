{ cabal, either, safe, transformers }:

cabal.mkDerivation (self: {
  pname = "errors";
  version = "1.4.4";
  sha256 = "1mhh5xna5nppqg8aw93iil7nsnpx5j6r21a12bx4mmip8nzr6480";
  buildDepends = [ either safe transformers ];
  jailbreak = true;
  meta = {
    description = "Simplified error-handling";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
