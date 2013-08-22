{ cabal, utf8String, xml }:

cabal.mkDerivation (self: {
  pname = "feed";
  version = "0.3.9.1";
  sha256 = "1c7dj9w9qj8408qql1kfq8m28fwvfd7bpgkj32lmk5x9qm5iz04k";
  buildDepends = [ utf8String xml ];
  meta = {
    homepage = "https://github.com/sof/feed";
    description = "Interfacing with RSS (v 0.9x, 2.x, 1.0) + Atom feeds.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
