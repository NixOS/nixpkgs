{ cabal }:

cabal.mkDerivation (self: {
  pname = "cereal";
  version = "0.3.5.1";
  sha256 = "1a9ri0fs0vh75c9llpjyvqp6qkjciqri6adpyn7hbqrn2z1h0l5n";
  meta = {
    description = "A binary serialization library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
