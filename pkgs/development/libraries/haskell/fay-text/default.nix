{ cabal, fay, fayBase, text }:

cabal.mkDerivation (self: {
  pname = "fay-text";
  version = "0.3.0.1";
  sha256 = "1bwsnhrj94j8jks5nhb0al8mymcgn2lp1pj9q7n935ygkzsaasbm";
  buildDepends = [ fay fayBase text ];
  meta = {
    homepage = "https://github.com/faylang/fay-text";
    description = "Fay Text type represented as JavaScript strings";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
