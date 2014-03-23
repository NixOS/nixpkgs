{ cabal, dlist, filepath, transformers }:

cabal.mkDerivation (self: {
  pname = "Glob";
  version = "0.7.4";
  sha256 = "00f6xznqh27vbr8rggsrdphqsq1cvv931pa06b1grs7w01dcmw8s";
  buildDepends = [ dlist filepath transformers ];
  meta = {
    homepage = "http://iki.fi/matti.niemenmaa/glob/";
    description = "Globbing library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
