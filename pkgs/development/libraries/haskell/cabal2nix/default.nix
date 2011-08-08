{fetchgit,cabal,HTTP}:

cabal.mkDerivation (self : {
  pname = "cabal2nix";
  version = "v1.8-beta-9";

  src = fetchgit {
    url = "git://github.com/peti/cabal2nix.git";
    rev = "8ba91f9b69851c55a4414e40e27b132754be4885";
  };

  propagatedBuildInputs = [HTTP];
  meta = {
    homepage = "http://github.com/peti/cabal2nix";
    description = "Convert Cabal files into Nix build instructions";
    license = self.stdenv.lib.licenses.bsd3;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
