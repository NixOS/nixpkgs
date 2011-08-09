{ fetchgit, cabal, HTTP, regexPosix }:

cabal.mkDerivation (self : {
  pname = "cabal2nix";
  version = "v1.8-beta-13";

  src = fetchgit {
    url = "git://github.com/peti/cabal2nix.git";
    rev = "11fb101a229373d37704b3b9e62df44c825dd081";
  };

  extraBuildInputs = [HTTP regexPosix];

  meta = {
    homepage = "http://github.com/peti/cabal2nix";
    description = "Convert Cabal files into Nix build instructions";
    license = self.stdenv.lib.licenses.bsd3;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
