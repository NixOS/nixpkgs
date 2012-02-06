{ cabal, Chart, cmdargs, colour, hledger, hledgerLib, HUnit, safe
, time
}:

cabal.mkDerivation (self: {
  pname = "hledger-chart";
  version = "0.16.1";
  sha256 = "1yk563032ir98gqdvxazjjl1alg6q1pflzawh11pr3zrdnriracn";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    Chart cmdargs colour hledger hledgerLib HUnit safe time
  ];
  patchPhase = ''
    sed -i hledger-chart.cabal -e 's|Chart >= 0.11 && < 0.15|Chart|g'
  '';
  meta = {
    homepage = "http://hledger.org";
    description = "A pie chart image generator for the hledger accounting tool";
    license = "GPL";
    platforms = self.stdenv.lib.platforms.linux;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
