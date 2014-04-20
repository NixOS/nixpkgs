{ cabal, cereal, monadsTf, random, transformers }:

cabal.mkDerivation (self: {
  pname = "AES";
  version = "0.2.8";
  sha256 = "1yf0mhmj294gf1b1m11gixa1xxlbvv0yl60b59fnv5lf0s170jn3";
  buildDepends = [ cereal monadsTf random transformers ];
  meta = {
    description = "Fast AES encryption/decryption for bytestrings";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
