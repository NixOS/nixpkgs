{ cabal, blazeBuilder, happy, mtl, utf8Light, utf8String }:

cabal.mkDerivation (self: {
  pname = "language-javascript";
  version = "0.5.0";
  sha256 = "0fx087z8sa360bsbd22g7jsnzz0dzvm6pfr59d4vamfwc0zg2yg9";
  isLibrary = true;
  isExecutable = true;
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
