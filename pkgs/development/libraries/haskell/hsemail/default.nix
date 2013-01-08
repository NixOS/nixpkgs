{ cabal, mtl, parsec }:

cabal.mkDerivation (self: {
  pname = "hsemail";
  version = "1.7.4";
  sha256 = "0nigv0zbkm90m5jskfc5a4zx2d3gyqj1y472jplrgd76s15alsmw";
  buildDepends = [ mtl parsec ];
  meta = {
    homepage = "http://gitorious.org/hsemail";
    description = "Internet Message Parsers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
