{ cabal, haskellLexer }:

cabal.mkDerivation (self: {
  pname = "pretty-show";
  version = "1.1.1";
  sha256 = "0w6r68l1452vh9aqnlh4066y62h8ylh45gbsl5l558wjgchlna5k";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ haskellLexer ];
  meta = {
    homepage = "http://wiki.github.com/yav/pretty-show";
    description = "Tools for working with derived Show instances.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
