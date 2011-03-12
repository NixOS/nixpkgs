{cabal, parsec, time, text, utf8String, parallel, syb}:

cabal.mkDerivation (self : {
  pname = "HStringTemplate";
  version = "0.6.6";
  sha256 = "1ian79az5q6m08pwb5fks52ffs4h2mq02kkcwmr6jb7i0ha2k2si";
  propagatedBuildInputs = [parsec time text utf8String parallel syb];
  meta = {
    description = "StringTemplate implementation in Haskell";
  };
})  

