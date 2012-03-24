{ cabal, mtl, parsec }:

cabal.mkDerivation (self: {
  pname = "hsemail";
  version = "1.7.1";
  sha256 = "0059015ab93d5facf6060404984a295090ebfc667ae5b84b283163e126805a9e";
  buildDepends = [ mtl parsec ];
  meta = {
    homepage = "http://gitorious.org/hsemail";
    description = "Internet Message Parsers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
