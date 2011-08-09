{fetchgit,cabal,HTTP}:

cabal.mkDerivation (self : {
  pname = "cabal2nix";
  version = "v1.8-beta-10";

  src = fetchgit {
    url = "git://github.com/peti/cabal2nix.git";
    rev = "3c91f4d1c5a881ebf5bf7eef3771f0267c08bad4";
  };

  propagatedBuildInputs = [HTTP];
  meta = {
    homepage = "http://github.com/peti/cabal2nix";
    description = "Convert Cabal files into Nix build instructions";
    license = self.stdenv.lib.licenses.bsd3;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
