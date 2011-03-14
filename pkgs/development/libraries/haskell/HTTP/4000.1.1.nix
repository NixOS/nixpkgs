{cabal, mtl, network, parsec}:

cabal.mkDerivation (self : {
  pname = "HTTP";
  version = "4000.1.1"; # Haskell Platform 2011.2.0.0
  sha256 = "09khx5fb673a0d7m3bl39xjdxvc60m52rmm4865cha2mby0zidy3";
  propagatedBuildInputs = [mtl network parsec];
  meta = {
    description = "a Haskell library for client-side HTTP";
  };
})

