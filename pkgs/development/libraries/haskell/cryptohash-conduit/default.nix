{ cabal, conduit, cryptohash, transformers }:

cabal.mkDerivation (self: {
  pname = "cryptohash-conduit";
  version = "0.1.0";
  sha256 = "08x45dy5crxc63gd4psryrzprz7lc5hbzjl23q56c3iqbvrx2r7w";
  buildDepends = [ conduit cryptohash transformers ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-cryptohash-conduit";
    description = "cryptohash conduit";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
