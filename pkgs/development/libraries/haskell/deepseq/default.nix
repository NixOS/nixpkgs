{cabal}:

cabal.mkDerivation (self : {
  pname = "deepseq";
  version = "1.1.0.0"; # Haskell Platform 2010.1.0.0
  sha256 = "947c45e7ee862159f190fb8e905c1328f7672cb9e6bf3abd1d207bbcf1eee50a";
  meta = {
    description = "Provides a deep version of seq, for fully evaluating data structures";
  };
})

