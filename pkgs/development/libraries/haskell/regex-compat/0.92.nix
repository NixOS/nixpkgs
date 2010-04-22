{cabal, regexBase, regexPosix}:

cabal.mkDerivation (self : {
  pname = "regex-compat";
  version = "0.92"; # Haskell Platform 2010.1.0.0
  sha256 = "430d251bd704071fca1e38c9b250543f00d4e370382ed552ac3d7407d4f27936";
  propagatedBuildInputs = [regexBase regexPosix];
  meta = {
    description = "Replaces/Enhances Text.Regex";
  };
})  

