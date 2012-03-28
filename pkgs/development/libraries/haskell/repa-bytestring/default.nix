{ cabal, repa, vector }:

cabal.mkDerivation (self: {
  pname = "repa-bytestring";
  version = "2.2.0.1";
  sha256 = "0yc814wyiy5cb9j04515rv24mm4qd5xqyz2dxsmg1p46qb69hvsg";
  buildDepends = [ repa vector ];
  meta = {
    homepage = "http://repa.ouroborus.net";
    description = "Conversions between Repa Arrays and ByteStrings";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
