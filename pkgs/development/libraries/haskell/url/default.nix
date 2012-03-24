{ cabal, utf8String }:

cabal.mkDerivation (self: {
  pname = "url";
  version = "2.1.3";
  sha256 = "0qag18wbrq9jjk1444mjigz1xl7xl03fz66b1lnya9qaihzpxwjs";
  buildDepends = [ utf8String ];
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/Url";
    description = "A library for working with URLs";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
