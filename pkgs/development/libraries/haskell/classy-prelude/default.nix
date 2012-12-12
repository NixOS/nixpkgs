{ cabal, basicPrelude, hashable, systemFilepath, text, transformers
, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "classy-prelude";
  version = "0.4.2";
  sha256 = "082zqhyswzlnl250g8pf88nmh7pkwxwjwnkp0pm9960qsl6kbn7s";
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
