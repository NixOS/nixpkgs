{ cabal }:

cabal.mkDerivation (self: {
  pname = "bytestring-nums";
  version = "0.3.5";
  sha256 = "12knbyrvr1wa7za8bwypvq3cp81k18qi032dl98s2ylhcz1r6rdk";
  isLibrary = true;
  isExecutable = true;
  meta = {
    homepage = "http://github.com/solidsnack/bytestring-nums";
    description = "Parse numeric literals from ByteStrings";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
