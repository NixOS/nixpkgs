{ cabal, repa, vector }:

cabal.mkDerivation (self: {
  pname = "repa-bytestring";
  version = "2.1.0.1";
  sha256 = "01kvbd1kn0irldnfihhxa2jrz8fy1x9g7vz60ffgagj6yzp4bsnq";
  buildDepends = [ repa vector ];
  meta = {
    homepage = "http://repa.ouroborus.net";
    description = "Conversions between Repa Arrays and ByteStrings.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
