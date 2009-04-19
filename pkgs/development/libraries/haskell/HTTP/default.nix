{cabal, mtl, network, parsec}:

cabal.mkDerivation (self : {
  pname = "HTTP";
  version = "4000.0.5"; # Haskell Platform 2009.0.0
  sha256 = "54cbb211e73f183aa91780afd6cc7c830edef1b2eb5ce8dc05e5fa539bb685d8";
  propagatedBuildInputs = [mtl network parsec];
  meta = {
    description = "a Haskell library for client-side HTTP";
  };
})

