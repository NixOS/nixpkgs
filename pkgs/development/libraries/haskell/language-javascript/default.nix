{ cabal, blazeBuilder, happy, mtl, utf8Light, utf8String }:

cabal.mkDerivation (self: {
  pname = "language-javascript";
  version = "0.5.1";
  sha256 = "12nb951xcsg1qxrg347f4sxmdzi78vxwkjhx0fib6pkbcz9yqf5q";
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
