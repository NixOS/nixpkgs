{cabal, parsec, time, text, utf8String, parallel}:

cabal.mkDerivation (self : {
  pname = "HStringTemplate";
  version = "0.6.2";
  sha256 = "1d8ae847cb2b92f6d083ee1ed5db00c719e51fe43017d4289dea61335a116103";
  propagatedBuildInputs = [parsec time text utf8String parallel];
  meta = {
    description = "StringTemplate implementation in Haskell";
  };
})  

