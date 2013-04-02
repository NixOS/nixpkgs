{ cabal, transformers }:

cabal.mkDerivation (self: {
  pname = "mtl";
  version = "2.1.2";
  sha256 = "1vwb98ci3jnjpndym012amia41h3cjdwpy9330ws881l6dj5fxwc";
  buildDepends = [ transformers ];
  meta = {
    homepage = "http://github.com/ekmett/mtl";
    description = "Monad classes, using functional dependencies";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
