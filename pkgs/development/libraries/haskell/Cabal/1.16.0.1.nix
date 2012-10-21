{ cabal, filepath }:

cabal.mkDerivation (self: {
  pname = "Cabal";
  version = "1.16.0.1";
  sha256 = "03h0fsdm00i5pq37j3d7rjw3gnqkmacvgvdhcrmmamn5q81qld5g";
  buildDepends = [ filepath ];
  meta = {
    homepage = "http://www.haskell.org/cabal/";
    description = "A framework for packaging Haskell software";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
