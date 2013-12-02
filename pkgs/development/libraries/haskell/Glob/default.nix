{ cabal, dlist, filepath, transformers }:

cabal.mkDerivation (self: {
  pname = "Glob";
  version = "0.7.2";
  sha256 = "1x4gh7z9jx9hdkjwsc31yyjssw6i7ziixhjrxr9b8zkijk1b4r5i";
  buildDepends = [ dlist filepath transformers ];
  jailbreak = true;
  meta = {
    homepage = "http://iki.fi/matti.niemenmaa/glob/";
    description = "Globbing library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
