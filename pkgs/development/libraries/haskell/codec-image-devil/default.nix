{ cabal, libdevil }:

cabal.mkDerivation (self: {
  pname = "Codec-Image-DevIL";
  version = "0.2.3";
  sha256 = "1kv3hns9f0bhfb723nj9szyz3zfqpvy02azzsiymzjz4ajhqmrsz";
  buildDepends = [ libdevil ];
  meta = {
    homepage = "http://hackage.haskell.org/package/Codec-Image-DevIL";
    description = "Simple FFI interface to the DevIL image library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
