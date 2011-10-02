{ cabal, cmdargs, hledger, hledgerLib, HUnit, safe, time, vty }:

cabal.mkDerivation (self: {
  pname = "hledger-vty";
  version = "0.16";
  sha256 = "161ziq4vwg6wsxijq065g1dpfnvcpxzzbarsj7znbqq4gs02mxx2";
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
