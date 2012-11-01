{ cabal }:

cabal.mkDerivation (self: {
  pname = "lrucache";
  version = "1.1.1.1";
  sha256 = "0w310wsvin5hw3awpicnzddyifcq0844h52jwjcqnin81l2lqrfw";
  meta = {
    homepage = "http://github.com/chowells79/lrucache";
    description = "a simple, pure LRU cache";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
