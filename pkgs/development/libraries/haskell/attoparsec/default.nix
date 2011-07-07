{cabal, deepseq}:

cabal.mkDerivation (self : {
  pname = "attoparsec";
  version = "0.9.1.1";
  sha256 = "1qkkl9pzk4znqh34pchmxbcslybvii35lkxhwf6445lyhj20356b";
  propagatedBuildInputs = [deepseq];
  meta = {
    description = "Fast combinator parsing for bytestrings";
    license = "BSD3";
  };
})

