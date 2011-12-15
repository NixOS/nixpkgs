{ cabal, monadControl, transformers }:

cabal.mkDerivation (self: {
  pname = "pool";
  version = "0.1.2";
  sha256 = "05lrinyk9gxdf67vwdav93ral2y8qsb33i9y5k91vlcjfp7w516q";
  buildDepends = [ monadControl transformers ];
  meta = {
    homepage = "http://www.yesodweb.com/book/persistent";
    description = "Thread-safe resource pools";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
