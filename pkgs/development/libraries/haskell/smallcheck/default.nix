{ cabal, logict, mtl }:

cabal.mkDerivation (self: {
  pname = "smallcheck";
  version = "1.1.0.1";
  sha256 = "02yv4pa6hilxl7fwskayd5nzs4hq46k91wh04sqj4yfk2s3pgb0m";
  buildDepends = [ logict mtl ];
  meta = {
    homepage = "https://github.com/feuerbach/smallcheck";
    description = "A property-based testing library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.ocharles
    ];
  };
})
