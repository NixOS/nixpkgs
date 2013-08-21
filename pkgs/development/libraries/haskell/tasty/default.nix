{ cabal, ansiTerminal, mtl, optparseApplicative, regexPosix, stm
, tagged
}:

cabal.mkDerivation (self: {
  pname = "tasty";
  version = "0.2";
  sha256 = "1shd4bl0wb67abs7vv3cagvpinkz2348fh7fdh3rq8l5g1jflp8q";
  buildDepends = [
    ansiTerminal mtl optparseApplicative regexPosix stm tagged
  ];
  meta = {
    description = "Modern and extensible testing framework";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
