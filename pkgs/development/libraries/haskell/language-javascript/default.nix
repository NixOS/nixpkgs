{ cabal, alex, happy, mtl, utf8Light }:

cabal.mkDerivation (self: {
  pname = "language-javascript";
  version = "0.4.5";
  sha256 = "0rsggjpxsvaipkibhl90qcj2w2i16g53srbb54v0hajx2msmi0ci";
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
