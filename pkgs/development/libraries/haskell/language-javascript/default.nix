{ cabal, blazeBuilder, happy, mtl, utf8Light, utf8String }:

cabal.mkDerivation (self: {
  pname = "language-javascript";
  version = "0.5.6";
  sha256 = "1a1nki2z7x0rna5jg6g0gqnipvd115k4xgagg6prrvj284ml44wd";
  buildDepends = [ blazeBuilder mtl utf8Light utf8String ];
  buildTools = [ happy ];
  meta = {
    homepage = "http://github.com/alanz/language-javascript";
    description = "Parser for JavaScript";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
