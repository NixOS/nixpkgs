{cabal, parsec, time, text, utf8String, parallel}:

cabal.mkDerivation (self : {
  pname = "HStringTemplate";
  version = "0.6.5";
  sha256 = "e40b69e22900f381ca7fb080ea6e70d623e52e909bd7b896bc24e15c8e43252c";
  propagatedBuildInputs = [parsec time text utf8String parallel];
  meta = {
    description = "StringTemplate implementation in Haskell";
  };
})  

