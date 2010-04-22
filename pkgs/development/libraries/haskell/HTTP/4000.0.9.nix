{cabal, mtl, network, parsec}:

cabal.mkDerivation (self : {
  pname = "HTTP";
  version = "4000.0.9"; # Haskell Platform 2010.1.0.0
  sha256 = "1e2b4a8b782ad1417c8755bb0d248851bc142b351366ed460e07f2945a5e95ba";
  propagatedBuildInputs = [mtl network parsec];
  meta = {
    description = "a Haskell library for client-side HTTP";
  };
})

