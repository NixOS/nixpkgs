{ cabal, cmdargs, hledger, hledgerLib, HUnit, safe, time, vty }:

cabal.mkDerivation (self: {
  pname = "hledger-vty";
  version = "0.16.1";
  sha256 = "10aq9apxz6nrzvvynha0wkhy34dn8dybizr8assni6rns8ylh188";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ cmdargs hledger hledgerLib HUnit safe time vty ];
  meta = {
    homepage = "http://hledger.org";
    description = "A curses-style console interface for the hledger accounting tool";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
