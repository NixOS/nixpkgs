{cabal, ghcPaths, haskellSrcMeta}:

cabal.mkDerivation (self : {
  pname = "vacuum";
  version = "0.0.94";
  sha256 = "7056dfa38a9f579ee897d2980938fd484ddfa93c472014ad7ea5a5cd9100bfad";
  propagatedBuildInputs = [ghcPaths haskellSrcMeta];
  meta = {
    description = "Extract graph representations of ghc heap values";
  };
})  

