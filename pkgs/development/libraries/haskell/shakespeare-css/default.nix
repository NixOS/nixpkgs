{ cabal, parsec, shakespeare, text }:

cabal.mkDerivation (self: {
  pname = "shakespeare-css";
  version = "0.10.1";
  sha256 = "1qdql6qcm7jzb5r1fvrmpyighn1ykrjgs9za1n9m2r47y0n03hsg";
  buildDepends = [ parsec shakespeare text ];
  meta = {
    homepage = "http://www.yesodweb.com/book/templates";
    description = "Stick your haskell variables into css at compile time";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
