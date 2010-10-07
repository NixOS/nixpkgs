{cabal, binary, mtl}:

cabal.mkDerivation (self : {
  pname = "ghc-events";
  version = "0.2.0.1";
  sha256 = "18cb82ebe143f58a25bf32ee88118a8bfb333b67a53285c2550e866f2afebbc6";
  propagatedBuildInputs = [binary mtl];
  meta = {
    description = "Library and tool for parsing .eventlog files from GHC";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})
