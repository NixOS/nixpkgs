{ cabal, binary, mtl }:

cabal.mkDerivation (self: {
  pname = "ghc-events";
  version = "0.4.0.1";
  sha256 = "1ic8r3hn1m500xwq1n8wz7fp65vm43n7dkjnn341xdmpd1546wlc";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ binary mtl ];
  noHaddock = true;
  meta = {
    description = "Library and tool for parsing .eventlog files from GHC";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
