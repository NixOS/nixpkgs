{ cabal, binary }:

cabal.mkDerivation (self: {
  pname = "SHA";
  version = "1.5.1";
  sha256 = "009c0nabva0c4aq4yhqdmdqmrrjmg8scpy7yz65bbhqnfwnjvdks";
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
