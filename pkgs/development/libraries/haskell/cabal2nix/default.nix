{cabal,HTTP}:

cabal.mkDerivation (self : {
  pname = "cabal2nix";
  version = "1.7";
  sha256 = "1inb1rv11dphgvg72zyfmzkcmw7dac1jrc40s7frhvwjhrnr4syv";
  propagatedBuildInputs = [HTTP];
  meta = {
    homepage = "http://github.com/peti/cabal2nix";
    description = "Convert Cabal files into Nix build instructions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.stdenv.lib.platforms.haskellPlatforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
