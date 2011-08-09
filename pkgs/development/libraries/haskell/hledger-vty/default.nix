{cabal, hledger, hledgerLib, vty, safe}:

cabal.mkDerivation (self : {
  pname = "hledger-vty";
  version = "0.14";
  sha256 = "3d9972430053548a65bfe5fb39ba374d1c930c6e0cfc704be5c59de742a4287e";
  propagatedBuildInputs = [hledger hledgerLib vty safe];
  meta = {
    description = "a simple curses-style console interface to hledger";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
