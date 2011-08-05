{cabal, parsec}:

cabal.mkDerivation (self : {
  pname = "network";
  version = "2.3.0.5"; # Haskell Platform future?
  sha256 = "0y1sbgsffzr0skm6xl8907iclgw9vmf395zvpwgakp69i3snh1z0";
  propagatedBuildInputs = [parsec];
  meta = {
    description = "Networking-related facilities";
  };
})

