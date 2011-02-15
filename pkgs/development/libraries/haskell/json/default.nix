{cabal, mtl}:

cabal.mkDerivation (self : {
  pname = "json";
  version = "0.4.4";
  sha256 = "102qmz55b2mgcca3q1c2pkcr6hz7kmpldad3f6blhmp1cz15f081";
  propagatedBuildInputs = [mtl];
  meta = {
    description = "Support for serialising Haskell to and from JSON";
  };
})  

