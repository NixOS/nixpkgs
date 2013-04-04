{ cabal, newtype, vectorSpace }:

cabal.mkDerivation (self: {
  pname = "vector-space-points";
  version = "0.1.2.1";
  sha256 = "0prbmk48xdr2gbxqpv0g89xz5v3k9wps9v2gymkh32jag2lgzi66";
  buildDepends = [ newtype vectorSpace ];
  meta = {
    description = "A type for points, as distinct from vectors";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
