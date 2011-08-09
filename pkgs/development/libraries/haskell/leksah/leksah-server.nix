{cabal, binary, binaryShared, deepseq, ghc, haddock, hslogger, ltk,
 mtl, network, parsec, processLeksah} :

cabal.mkDerivation (self : {
  pname = "leksah-server";
  version = "0.10.0.4";
  sha256 = "0g523dkiaclk5ym16vzqiabh7mwksjqp0kbx17a899k5gzfwfjp6";
  propagatedBuildInputs = [
    binary binaryShared deepseq ghc haddock hslogger ltk mtl network
    parsec processLeksah
  ];
  meta = {
    homepage = "http://leksah.org";
    description = "Metadata collection for leksah";
    license = "GPL";
    platforms = self.stdenv.lib.platforms.linux;
    maintainers = [
      self.stdenv.lib.maintainers.simons
      self.stdenv.lib.maintainers.andres
    ];
  };
})
