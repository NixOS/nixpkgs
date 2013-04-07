{ cabal, doctest, hspec, mtl, parsec }:

cabal.mkDerivation (self: {
  pname = "hsemail";
  version = "1.7.6";
  sha256 = "0v4c6ljrzc7680i85wyxq7fkfs2j00941ps3rn8r16x3x2r8di04";
  buildDepends = [ mtl parsec ];
  testDepends = [ doctest hspec parsec ];
  meta = {
    homepage = "http://github.com/peti/hsemail";
    description = "Internet Message Parsers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
