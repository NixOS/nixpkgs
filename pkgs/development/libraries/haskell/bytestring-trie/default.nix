{ cabal, binary }:

cabal.mkDerivation (self: {
  pname = "bytestring-trie";
  version = "0.2.3";
  sha256 = "1zb4s7fd951swc648szrpx0ldailmdinapgbcg1zajb5c5jq57ga";
  buildDepends = [ binary ];
  meta = {
    homepage = "http://code.haskell.org/~wren/";
    description = "An efficient finite map from (byte)strings to values";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
