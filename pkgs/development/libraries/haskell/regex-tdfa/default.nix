{cabal, mtl, parsec, regexBase}:

cabal.mkDerivation (self : {
  pname = "regex-tdfa";
  version = "1.1.8";
  sha256 = "1m75xh5bwmmgg5f757dc126kv47yfqqnz9fzj1hc80p6jpzs573x";
  propagatedBuildInputs = [mtl parsec regexBase];
  meta = {
    description = "Replaces/Enhances Text.Regex";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})
