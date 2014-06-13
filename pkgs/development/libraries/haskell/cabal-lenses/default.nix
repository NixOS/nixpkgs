{ cabal, Cabal, lens, unorderedContainers }:

cabal.mkDerivation (self: {
  pname = "cabal-lenses";
  version = "0.2";
  sha256 = "1wfr4rh7ba1hsvi0v7mzpab7fi5k93lz27v8qdfjqzkyybhjglv4";
  buildDepends = [ Cabal lens unorderedContainers ];
  jailbreak = true;
  meta = {
    description = "Lenses and traversals for the Cabal library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
