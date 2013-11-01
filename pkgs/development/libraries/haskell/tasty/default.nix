{ cabal, ansiTerminal, mtl, optparseApplicative, regexPosix, stm
, tagged
}:

cabal.mkDerivation (self: {
  pname = "tasty";
  version = "0.3.1";
  sha256 = "0ipndrpywzg40s5hiwyyly29mcppcfqbbpwqqp4apma57m8cdpb0";
  buildDepends = [
    ansiTerminal mtl optparseApplicative regexPosix stm tagged
  ];
  meta = {
    description = "Modern and extensible testing framework";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
