{cabal, binary, mtl}:

cabal.mkDerivation (self : {
  pname = "ghc-events";
  version = "0.2.0.1";
  sha256 = "18cb82ebe143f58a25bf32ee88118a8bfb333b67a53285c2550e866f2afebbc6";
  propagatedBuildInputs = [binary mtl];
  preConfigure = ''
    sed -i 's|\(containers.*\) && < 0.4|\1|' ${self.pname}.cabal
  '';
  meta = {
    description = "Library and tool for parsing .eventlog files from GHC";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
