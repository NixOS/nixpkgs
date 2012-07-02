{ cabal, text }:

cabal.mkDerivation (self: {
  pname = "xml-types";
  version = "0.3.2";
  sha256 = "1aihs1n6hxq6frvxdqjqxsfwi2w2c2qx4bjypimjpjxf6d6n1396";
  buildDepends = [ text ];
  meta = {
    homepage = "https://john-millikin.com/software/haskell-xml/";
    description = "Basic types for representing XML";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
