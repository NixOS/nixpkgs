{fetchgit,cabal,HTTP}:

cabal.mkDerivation (self : {
  pname = "cabal2nix";
  version = "v1.8-beta-11";

  src = fetchgit {
    url = "git://github.com/peti/cabal2nix.git";
    rev = "aeba53e8da1250603b227ad2c705eee446cd3337";
  };

  propagatedBuildInputs = [HTTP];
  meta = {
    homepage = "http://github.com/peti/cabal2nix";
    description = "Convert Cabal files into Nix build instructions";
    license = self.stdenv.lib.licenses.bsd3;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
