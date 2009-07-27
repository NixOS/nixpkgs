{cabal,mtl}:

cabal.mkDerivation (self : {
  pname = "parsec";
  version = "3.0.0"; # Haskell Platform 2009.0.0
  sha256 = "0fqryy09y8h7z0hlayg5gpavghgwa0g3bldynwl17ks8l87ykj7a";
  propagatedBuildInputs = [mtl];
  meta = {
    description = "Monadic parser combinators";
  };
})  

