{ cabal, binary }:

cabal.mkDerivation (self: {
  pname = "SHA";
  version = "1.6.1";
  sha256 = "1v3a2skkbr64y7x1aqpq1qz03isc42l9hd1viqcsv4qlld595fgx";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ binary ];
  meta = {
    description = "Implementations of the SHA suite of message digest functions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
