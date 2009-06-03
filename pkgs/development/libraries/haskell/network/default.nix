{cabal, parsec}:

cabal.mkDerivation (self : {
  pname = "network";
  version = "2.2.1.1"; # Haskell Platform 2009.2.0.1
  sha256 = "2b1fb2a16ed740636871662f2e38dffd9b7c13c61e28d887a1c334da3867da9d";
  propagatedBuildInputs = [parsec];
  meta = {
    description = "Networking-related facilities";
  };
})  

