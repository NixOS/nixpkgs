{ cabal, dlist, filepath, transformers }:

cabal.mkDerivation (self: {
  pname = "Glob";
  version = "0.7.3";
  sha256 = "0yl0wxbd03dv0hfr2aqwm9f3xnhjkdicymqv3nmhjjslqq3a59zd";
  buildDepends = [ dlist filepath transformers ];
  meta = {
    homepage = "http://iki.fi/matti.niemenmaa/glob/";
    description = "Globbing library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
