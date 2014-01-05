{ cabal }:

cabal.mkDerivation (self: {
  pname = "monoid-transformer";
  version = "0.0.2";
  sha256 = "0hd8jb1iw6lbgml3f08n680bdij56cjanpkr4fc1jr7qn6yzzb2j";
  meta = {
    description = "Monoid counterparts to some ubiquitous monad transformers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
