{cabal, mtl}:

cabal.mkDerivation (self : {
  pname = "QuickCheck";
  version = "2.1.0.1";
  sha256 = "f99edf1a45315e90c9ec672d5d959d5878dcc1de65678c6aed85829a896b75f1";
  propagatedBuildInputs = [mtl];
  configureFlags = ''--constraint=base<4'';
  meta = {
    description = "Automatic testing of Haskell programs";
  };
})  

