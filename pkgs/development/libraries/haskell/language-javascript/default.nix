{ cabal, alex, happy, mtl, utf8Light }:

cabal.mkDerivation (self: {
  pname = "language-javascript";
  version = "0.4.9";
  sha256 = "19a8c8bq4s533iyb6h3vl59dnya6d7inaqk1hbhnlil1w2d0n5b5";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ mtl utf8Light ];
  buildTools = [ alex happy ];
  meta = {
    homepage = "http://github.com/alanz/language-javascript";
    description = "Parser for JavaScript";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
