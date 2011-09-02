{ cabal, cmdargs, hledger, hledgerLib, HUnit, safe, time, vty }:

cabal.mkDerivation (self: {
  pname = "hledger-vty";
  version = "0.15";
  sha256 = "185j09chw34jjb0zayv526cs4rzgaygclzifmpwjk5bnrbx9b925";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ cmdargs hledger hledgerLib HUnit safe time vty ];
  meta = {
    homepage = "http://hledger.org";
    description = "A curses-style console interface for the hledger accounting tool";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
