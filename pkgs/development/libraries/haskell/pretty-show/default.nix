{ cabal, haskellLexer }:

cabal.mkDerivation (self: {
  pname = "pretty-show";
  version = "1.3.2";
  sha256 = "0m3kw4d68gd1mhlgi5vy3k2cqi9f0i4s502m2sgy4pww45fjllxy";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ haskellLexer ];
  meta = {
    homepage = "http://wiki.github.com/yav/pretty-show";
    description = "Tools for working with derived Show instances";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
