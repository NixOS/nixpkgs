{fetchgit,cabal,HTTP}:

cabal.mkDerivation (self : {
  pname = "cabal2nix";
  version = "v1.8-beta-4";

  src = fetchgit {
    url = "git://github.com/peti/cabal2nix.git";
    rev = "c108759bdf32a0291e6d9c4ed182f105a89e42a3";
  };

  propagatedBuildInputs = [HTTP];
  meta = {
    homepage = "http://github.com/peti/cabal2nix";
    description = "Convert Cabal files into Nix build instructions";
    license = self.stdenv.lib.licenses.bsd3;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
