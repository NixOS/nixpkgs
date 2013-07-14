{ cabal, bindingsDSL, pthread }:

cabal.mkDerivation (self: {
  pname = "bindings-posix";
  version = "1.2.3";
  sha256 = "0nj18lfpn8hmlaa7cmvdkjnk8fi2f6ysjbigkx7zbrpqnvbi63ba";
  buildDepends = [ bindingsDSL ];
  extraLibraries = [ pthread ];
  meta = {
    description = "Low level bindings to posix";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
