{ cabal, binary }:

cabal.mkDerivation (self: {
  pname = "SHA";
  version = "1.6.4";
  sha256 = "13d7sg8r0qqs425banrwd15hahy8gnl4k81q0wfqld77xpb2vvbj";
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
