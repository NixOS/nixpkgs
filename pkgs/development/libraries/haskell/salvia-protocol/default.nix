{ cabal, bimap, fclabels, parsec, safe, split, utf8String }:

cabal.mkDerivation (self: {
  pname = "salvia-protocol";
  version = "1.0.1";
  sha256 = "6b2312e52efaa81feec7461b1a3db77e1f2a8dfd829ae878b614c206a5e48928";
  buildDepends = [ bimap fclabels parsec safe split utf8String ];
  meta = {
    description = "Salvia webserver protocol suite supporting URI, HTTP, Cookie and MIME";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
