{ cabal, dlist }:

cabal.mkDerivation (self: {
  pname = "smallcheck";
  version = "0.6";
  sha256 = "19b2dyjbryx2a5bq70pn2mbzlcvjjwhii78fwwx6q57r13zljb9v";
  buildDepends = [ dlist ];
  meta = {
    homepage = "https://github.com/feuerbach/smallcheck";
    description = "A property-based testing library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
