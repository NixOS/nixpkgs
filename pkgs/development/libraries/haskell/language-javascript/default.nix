{ cabal, alex, Cabal, happy, mtl, utf8Light }:

cabal.mkDerivation (self: {
  pname = "language-javascript";
  version = "0.4.8";
  sha256 = "0zrvlr683r093v4nblxc4wcpb91gxw3y9a92dx02qi9v983pznf7";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ Cabal mtl utf8Light ];
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
