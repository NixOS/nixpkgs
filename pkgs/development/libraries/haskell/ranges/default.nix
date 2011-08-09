{ cabal }:

cabal.mkDerivation (self: {
  pname = "ranges";
  version = "0.2.3";
  sha256 = "1jmybrwwvg8zkbxjrlrahfavlf2g2584ld15hzhch317683nvr1p";
  meta = {
    description = "Ranges and various functions on them.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
