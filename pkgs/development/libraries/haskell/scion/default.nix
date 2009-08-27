{cabal, ghcPaths, ghcSyb, hslogger, json, multiset, time, uniplate}:

cabal.mkDerivation (self : {
  pname = "scion";
  version = "0.1";
  sha256 = "5c9fd9922182abed57c6ec260dfa497de411124c63851a72c640232b9cf78d83";
  propagatedBuildInputs = [ghcPaths ghcSyb hslogger json multiset time uniplate];
  meta = {
    description = "Haskell IDE library";
  };
})
