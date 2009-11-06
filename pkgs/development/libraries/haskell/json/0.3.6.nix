{cabal, mtl}:

cabal.mkDerivation (self : {
  pname = "json";
  version = "0.3.6";
  sha256 = "05047879ed0c7a9aa168a981e238da94758281af3cb1a1f78a6427322b946fd7";
  propagatedBuildInputs = [mtl];
  meta = {
    description = "Support for serialising Haskell to and from JSON";
  };
})  

