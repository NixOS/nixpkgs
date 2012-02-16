{ cabal, Cabal }:

cabal.mkDerivation (self: {
  pname = "binary";
  version = "0.5.1.0";
  sha256 = "18si0f021447b1kqshar224zyh02gc65z7v82waxcn4igss7gm1a";
  buildDepends = [ Cabal ];
  meta = {
    homepage = "http://code.haskell.org/binary/";
    description = "Binary serialisation for Haskell values using lazy ByteStrings";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
