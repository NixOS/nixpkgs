{cabal, regexBase, regexPosix}:

cabal.mkDerivation (self : {
  pname = "regex-compat";
  version = "0.93.1"; # Haskell Platform 2010.2.0.0, 2011.2.0.0
  sha256 = "1zlsx7a2iz5gmgrwzr6w5fz6s4ayab5bm71xlq28r3iph3vp80zf";
  propagatedBuildInputs = [regexBase regexPosix];
  meta = {
    description = "Replaces/Enhances Text.Regex";
  };
})

