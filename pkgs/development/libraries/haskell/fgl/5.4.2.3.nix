{cabal, mtl}:

cabal.mkDerivation (self : {
  pname = "fgl";
  version = "5.4.2.3"; # Haskell Platform 2010.2.0.0
  sha256 = "e72142b555a5ab6c5cdced317b42e8cafdbb54b7e2e46ed14e6ca18d71d486b8";
  propagatedBuildInputs = [mtl];
  meta = {
    description = "Martin Erwig's Functional Graph Library";
  };
})  

