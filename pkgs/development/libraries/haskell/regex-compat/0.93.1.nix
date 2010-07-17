{cabal, regexBase, regexPosix}:

cabal.mkDerivation (self : {
  pname = "regex-compat";
  version = "0.93.1"; # Haskell Platform 2010.2.0.0
  sha256 = "ee0374f780378e8c04a63d9cbaca525e116dbe2bdce4cff3abaffc28d4e99afe";
  propagatedBuildInputs = [regexBase regexPosix];
  meta = {
    description = "Replaces/Enhances Text.Regex";
  };
})  

