{ cabal, hledger, hledgerLib, safe, vty }:

cabal.mkDerivation (self: {
  pname = "hledger-vty";
  version = "0.14";
  sha256 = "3d9972430053548a65bfe5fb39ba374d1c930c6e0cfc704be5c59de742a4287e";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ hledger hledgerLib safe vty ];
  meta = {
    homepage = "http://hledger.org";
    description = "A curses-style interface for the hledger accounting tool.";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
