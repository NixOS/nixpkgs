{ cabal, cmdargs, hledger, hledgerLib, HUnit, safe, time, vty }:

cabal.mkDerivation (self: {
  pname = "hledger-vty";
  version = "0.15.1";
  sha256 = "069wzk4azc4rnf292809g0lsi07p1m9gjmrvwn0cy2bij2vrhi6n";
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
