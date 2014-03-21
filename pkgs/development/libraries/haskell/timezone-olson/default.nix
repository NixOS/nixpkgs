{ cabal, binary, extensibleExceptions, time, timezoneSeries }:

cabal.mkDerivation (self: {
  pname = "timezone-olson";
  version = "0.1.4";
  sha256 = "1l5j6gqi9vlx7sifn7vv3by4z9ha3h6klfds4ywqv3dv0gh5725k";
  buildDepends = [ binary extensibleExceptions time timezoneSeries ];
  meta = {
    homepage = "http://projects.haskell.org/time-ng/";
    description = "A pure Haskell parser and renderer for binary Olson timezone files";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
