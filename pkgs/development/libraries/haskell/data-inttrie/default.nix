{ cabal }:

cabal.mkDerivation (self: {
  pname = "data-inttrie";
  version = "0.0.7";
  sha256 = "19d586p2pj38pirrkip9z6yxrdbpiqsbnczmnyvd8slndilqz0ip";
  meta = {
    homepage = "http://github.com/luqui/data-inttrie";
    description = "A lazy, infinite trie of integers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
