{cabal, regexBase, pcre}:

cabal.mkDerivation (self : {
  pname = "regex-pcre";
  version = "0.94.2";
  sha256 = "0p4az8z4jlrcmmyz9bjf7n90hpg6n242vq4255w2dz5v29l822wn";
  propagatedBuildInputs = [regexBase];
  extraBuildInputs = [pcre];
  meta = {
    description = "Replaces/Enhances Text.Regex";
    license = "BSD3";
  };
})
