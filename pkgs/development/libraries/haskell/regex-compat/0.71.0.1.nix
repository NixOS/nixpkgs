{cabal, regexBase, regexPosix}:

cabal.mkDerivation (self : {
  pname = "regex-compat";
  version = "0.71.0.1"; # Haskell Platform 2009.0.0
  sha256 = "904552f7d690686b2602f37494827d09b09fc0a8a2565522b61847bec8d1de8d";
  propagatedBuildInputs = [regexBase regexPosix];
  meta = {
    description = "Replaces/Enhances Text.Regex";
  };
})

