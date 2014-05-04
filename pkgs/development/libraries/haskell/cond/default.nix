{ cabal }:

cabal.mkDerivation (self: {
  pname = "cond";
  version = "0.4.0.2";
  sha256 = "13m7bcsx4nch767kf9wza0vqql711b8vjd3m5cahrvb7xbh3g593";
  meta = {
    homepage = "https://github.com/kallisti-dev/cond";
    description = "Basic conditional and boolean operators with monadic variants";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
