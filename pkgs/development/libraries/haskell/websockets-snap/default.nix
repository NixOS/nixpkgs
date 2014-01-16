{ cabal, blazeBuilder, enumerator, ioStreams, mtl, snapCore
, snapServer, websockets
}:

cabal.mkDerivation (self: {
  pname = "websockets-snap";
  version = "0.8.2.0";
  sha256 = "0z6my5l1rm39prnhpvgg7z3q57y29ai3wddw1yfadrdsx8qra67s";
  buildDepends = [
    blazeBuilder enumerator ioStreams mtl snapCore snapServer
    websockets
  ];
  meta = {
    description = "Snap integration for the websockets library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
