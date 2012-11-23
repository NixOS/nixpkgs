{ cabal }:

cabal.mkDerivation (self: {
  pname = "stm";
  version = "2.4.2";
  sha256 = "1nsq92z7y0w227fyig0xz4365xp50hnzzkqr4s836q969kb3rvn8";
  meta = {
    description = "Software Transactional Memory";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
