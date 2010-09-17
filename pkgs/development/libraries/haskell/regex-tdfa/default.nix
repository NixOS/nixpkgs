{cabal, mtl, parsec, regexBase}:

cabal.mkDerivation (self : {
  pname = "regex-tdfa";
  version = "1.1.4";
  sha256 = "382c7ed1ee75448574b42e9ecb9228b25f55143f3008ecd6f5d3a30471337b39";
  propagatedBuildInputs = [mtl parsec regexBase];
  meta = {
    description = "Replaces/Enhances Text.Regex";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})
