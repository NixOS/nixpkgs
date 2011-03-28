{cabal, parsec}:

cabal.mkDerivation (self : {
  pname = "network";
  version = "2.2.1.4"; # Haskell Platform 2009.2.0.2
  sha256 = "16a842bee5db116f754b459ef261426b6705a6d79383c6d545c9df5f6329cd25";
  propagatedBuildInputs = [parsec];
  meta = {
    description = "Networking-related facilities";
  };
})

