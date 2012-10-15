{ cabal, alex, blazeBuilder, happy, mtl, utf8Light, utf8String }:

cabal.mkDerivation (self: {
  pname = "language-javascript";
  version = "0.5.5";
  sha256 = "1p02n6rh98nvkh7g5kj18ggcnyvds8lqbgjwgzm83bnd5ayizrw7";
  buildDepends = [ blazeBuilder mtl utf8Light utf8String ];
  buildTools = [ alex happy ];
  meta = {
    homepage = "http://github.com/alanz/language-javascript";
    description = "Parser for JavaScript";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
