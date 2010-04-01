{cabal, mtl}:

cabal.mkDerivation (self : {
  pname = "fgl";
  version = "5.4.2.2"; # Haskell Platform 2010.1.0.0
  sha256 = "8232c337f0792854bf2a12a5fd1bc46726fff05d2f599053286ff873364cd7d2";
  propagatedBuildInputs = [mtl];
  meta = {
    description = "Martin Erwig's Functional Graph Library";
  };
})  

