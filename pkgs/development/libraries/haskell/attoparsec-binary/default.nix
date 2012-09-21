{ cabal, attoparsec }:

cabal.mkDerivation (self: {
  pname = "attoparsec-binary";
  version = "0.1.0.1";
  sha256 = "1d3zjr8bh6d44v1vid0cvrrbyhn7xj4bn96vy36dzk7h7p87bzxa";
  buildDepends = [ attoparsec ];
  meta = {
    description = "Binary processing extensions to Attoparsec";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
