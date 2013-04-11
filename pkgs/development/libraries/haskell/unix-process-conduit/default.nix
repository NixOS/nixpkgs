{ cabal, conduit, hspec, transformers }:

cabal.mkDerivation (self: {
  pname = "unix-process-conduit";
  version = "0.2.0.2";
  sha256 = "1n9ja7dlxhsxyglfzk397xdgvdny766y1isrb5d065srxprsj2g6";
  buildDepends = [ conduit transformers ];
  testDepends = [ conduit hspec transformers ];
  meta = {
    homepage = "https://github.com/snoyberg/conduit";
    description = "Run processes on Unix systems, with a conduit interface";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
