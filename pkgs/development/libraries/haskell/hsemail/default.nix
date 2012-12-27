{ cabal, mtl, parsec }:

cabal.mkDerivation (self: {
  pname = "hsemail";
  version = "1.7.3";
  sha256 = "0i9qh4rbgcgpjiz7nj8rrmj0ai53s420dskfvwrbwl4j6z67f7la";
  buildDepends = [ mtl parsec ];
  meta = {
    homepage = "http://gitorious.org/hsemail";
    description = "Internet Message Parsers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
