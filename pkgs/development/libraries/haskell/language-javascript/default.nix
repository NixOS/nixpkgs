{ cabal, blazeBuilder, happy, mtl, utf8Light, utf8String }:

cabal.mkDerivation (self: {
  pname = "language-javascript";
  version = "0.5.2";
  sha256 = "0q9xy72z7i2ivqzbjzn9nl5y0x07d2y3a737yw26a4zhbmhwg236";
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
