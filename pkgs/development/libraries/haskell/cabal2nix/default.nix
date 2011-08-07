{fetchgit,cabal,HTTP}:

cabal.mkDerivation (self : {
  pname = "cabal2nix";
  version = "v1.8-beta-3";

  src = fetchgit {
    url = "git://github.com/peti/cabal2nix.git";
    rev = "26fb761aee1b3398b3ed18e3be89507964320e4f";
  };

  propagatedBuildInputs = [HTTP];
  meta = {
    homepage = "http://github.com/peti/cabal2nix";
    description = "Convert Cabal files into Nix build instructions";
    license = self.stdenv.lib.licenses.bsd3;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
