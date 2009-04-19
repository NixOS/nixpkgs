{cabal, parsec}:

cabal.mkDerivation (self : {
  pname = "network";
  version = "2.2.1"; # Haskell Platform 2009.0.0
  sha256 = "111e4963a0a979570993e79511a778b267ef58df35320d1ddda61a869259b63c";
  propagatedBuildInputs = [parsec];
  meta = {
    description = "Networking-related facilities";
  };
})  

