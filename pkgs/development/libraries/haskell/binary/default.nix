{ cabal }:

cabal.mkDerivation (self: {
  pname = "binary";
  version = "0.5.0.2";
  sha256 = "02qkybh11psmggkqcs7f8kh4izfj44gq1wk23xhv3jbxc7gdxhp0";
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
