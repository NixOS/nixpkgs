{cabal, mtl, network, parsec}:

cabal.mkDerivation (self : {
  pname = "HTTP";
  version = "4000.0.6"; # Haskell Platform 2009.1.1
  sha256 = "75af1ac4dc21b10c8a1a54a33179ea822e591887bab7278360a3d6b38304d39b";
  propagatedBuildInputs = [mtl network parsec];
  meta = {
    description = "a Haskell library for client-side HTTP";
  };
})

