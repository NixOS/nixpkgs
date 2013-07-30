{ cabal, utf8String, xml }:

cabal.mkDerivation (self: {
  pname = "feed";
  version = "0.3.9";
  sha256 = "0waqy8ssmbfpqy21svvbnm0igrjxbgd2i093hbl5chim6yraapv2";
  buildDepends = [ utf8String xml ];
  meta = {
    description = "Interfacing with RSS (v 0.9x, 2.x, 1.0) + Atom feeds.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
