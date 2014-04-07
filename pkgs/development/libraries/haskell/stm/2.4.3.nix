{ cabal }:

cabal.mkDerivation (self: {
  pname = "stm";
  version = "2.4.3";
  sha256 = "0vzw4s06d5scfy4ircl81ym8ylkw9ckzsp8rq950dvipmaj1xhis";
  meta = {
    description = "Software Transactional Memory";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
