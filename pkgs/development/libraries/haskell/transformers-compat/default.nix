{ cabal, transformers }:

cabal.mkDerivation (self: {
  pname = "transformers-compat";
  version = "0.1";
  sha256 = "100xw00h2l6iipg6lq5bbncpil3bl6w3frak99klpi8gn6ihd8ah";
  buildDepends = [ transformers ];
  noHaddock = true;
  meta = {
    homepage = "http://github.com/ekmett/transformers-compat/";
    description = "Lenses, Folds and Traversals";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
