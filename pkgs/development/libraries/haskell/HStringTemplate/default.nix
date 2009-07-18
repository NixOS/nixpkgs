{cabal, parsec, time}:

cabal.mkDerivation (self : {
  pname = "HStringTemplate";
  version = "0.5.1.3";
  sha256 = "1f9da3afcb2441d450051ea9836f25df69430eaf17593c39199ad686a828e044";
  propagatedBuildInputs = [parsec time];
  meta = {
    description = "StringTemplate implementation in Haskell";
  };
})  

