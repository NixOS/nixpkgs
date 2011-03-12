{cabal, mtl, network, parsec}:

cabal.mkDerivation (self : {
  pname = "HTTP";
  version = "3001.1.5"; 
  sha256 = "e34d9f979bafbbf2e45bf90a9ee9bfd291f3c67c291a250cc0a6378431578aeb";
  propagatedBuildInputs = [mtl network parsec];
  meta = {
    description = "a Haskell library for client-side HTTP";
  };
})

