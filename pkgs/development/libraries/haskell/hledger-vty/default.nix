{ cabal, cmdargs, hledger, hledgerLib, HUnit, safe, time, vty }:

cabal.mkDerivation (self: {
  pname = "hledger-vty";
  version = "0.15.2";
  sha256 = "0sii9psh1mm5f8w782bv2m5rxn29q23v17avhw0x5ssm9zy9yxqd";
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
