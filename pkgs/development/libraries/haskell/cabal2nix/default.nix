{ fetchgit, cabal, HTTP, regexPosix }:

cabal.mkDerivation (self : {
  pname = "cabal2nix";
  version = "v1.8-beta-12";

  src = fetchgit {
    url = "git://github.com/peti/cabal2nix.git";
    rev = "e4592ca95b35cc27a4239003085683f98b9ee83b";
  };

  extraBuildInputs = [HTTP regexPosix];

  meta = {
    homepage = "http://github.com/peti/cabal2nix";
    description = "Convert Cabal files into Nix build instructions";
    license = self.stdenv.lib.licenses.bsd3;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
