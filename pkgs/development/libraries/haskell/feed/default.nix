{ cabal, time, utf8String, xml }:

cabal.mkDerivation (self: {
  pname = "feed";
  version = "0.3.9.2";
  sha256 = "05sg2ly1pvni3sfv03rbf60vdjkrfa0f9mmc1dm1hrmp638j67gg";
  buildDepends = [ time utf8String xml ];
  meta = {
    homepage = "https://github.com/sof/feed";
    description = "Interfacing with RSS (v 0.9x, 2.x, 1.0) + Atom feeds.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
