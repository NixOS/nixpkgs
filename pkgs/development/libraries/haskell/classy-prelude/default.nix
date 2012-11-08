{ cabal, basicPrelude, hashable, systemFilepath, text, transformers
, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "classy-prelude";
  version = "0.4.0";
  sha256 = "0j84mv87g4hkpqdvh9cb7k4jzy1z4m8m4l1kz8j9z7sngaymhq9k";
  buildDepends = [
    basicPrelude hashable systemFilepath text transformers
    unorderedContainers vector
  ];
  meta = {
    homepage = "https://github.com/snoyberg/classy-prelude";
    description = "A typeclass-based Prelude";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
