{ cabal }:

cabal.mkDerivation (self: {
  pname = "byteorder";
  version = "1.0.4";
  sha256 = "06995paxbxk8lldvarqpb3ygcjbg4v8dk4scib1rjzwlhssvn85x";
  meta = {
    homepage = "http://community.haskell.org/~aslatter/code/byteorder";
    description = "Exposes the native endianness or byte ordering of the system";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
