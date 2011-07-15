{cabal, binary}:

cabal.mkDerivation (self : {
  pname = "bytestring-trie";
  version = "0.2.3";
  sha256 = "1zb4s7fd951swc648szrpx0ldailmdinapgbcg1zajb5c5jq57ga";
  propagatedBuildInputs = [binary];
  meta = {
    description = "An efficient finite map from (byte)strings to values";
    license = "BSD3";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})

