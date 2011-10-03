{ cabal, shakespeare, text }:

cabal.mkDerivation (self: {
  pname = "shakespeare-text";
  version = "0.10.2";
  sha256 = "04n1aflg4b5byfsg494d4dskx25nyy0a654wl4cxz8920sl7qpha";
  buildDepends = [ shakespeare text ];
  meta = {
    homepage = "http://www.yesodweb.com/book/templates";
    description = "Interpolation with quasi-quotation: put variables strings";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
