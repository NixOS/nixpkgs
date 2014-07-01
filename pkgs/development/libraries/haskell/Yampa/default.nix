{ cabal, random }:

cabal.mkDerivation (self: {
  pname = "Yampa";
  version = "0.9.5";
  sha256 = "0r6fm2ccls7gbc5s0vbrzrqv6marnzlzc7zr4afkgfk9jsqfmqjh";
  buildDepends = [ random ];
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/Yampa";
    description = "Library for programming hybrid systems";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
