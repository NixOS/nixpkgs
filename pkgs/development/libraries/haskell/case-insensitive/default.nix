{ cabal, hashable, text }:

cabal.mkDerivation (self: {
  pname = "case-insensitive";
  version = "0.4.0.4";
  sha256 = "1xzpri688vbd6fvvxczqx8bv53009ygzws7vbjmj2q97wcm8nmwd";
  buildDepends = [ hashable text ];
  meta = {
    homepage = "https://github.com/basvandijk/case-insensitive";
    description = "Case insensitive string comparison";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
