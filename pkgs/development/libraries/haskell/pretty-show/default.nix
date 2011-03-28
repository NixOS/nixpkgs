{cabal, haskellLexer}:

cabal.mkDerivation (self : {
  pname = "pretty-show";
  version = "1.1.1";
  sha256 = "0w6r68l1452vh9aqnlh4066y62h8ylh45gbsl5l558wjgchlna5k";
  propagatedBuildInputs = [haskellLexer];
  meta = {
    description = "Tools for working with derived Show instances";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})

