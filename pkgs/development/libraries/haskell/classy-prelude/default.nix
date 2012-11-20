{ cabal, basicPrelude, hashable, systemFilepath, text, transformers
, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "classy-prelude";
  version = "0.4.1";
  sha256 = "14s1qirss8qbicdw4bc7smdnk1xrpp1xsii8kgmrb1z4ji0h9bf1";
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
