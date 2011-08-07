{cabal, mtl, utf8Light, alex, happy} :

cabal.mkDerivation (self : {
  pname = "language-javascript";
  version = "0.4.5";
  sha256 = "0rsggjpxsvaipkibhl90qcj2w2i16g53srbb54v0hajx2msmi0ci";
  extraBuildInputs = [ alex happy ];
  propagatedBuildInputs = [ mtl utf8Light ];
  meta = {
    homepage = "http://github.com/alanz/language-javascript";
    description = "Parser for JavaScript";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.stdenv.lib.platforms.haskellPlatforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
