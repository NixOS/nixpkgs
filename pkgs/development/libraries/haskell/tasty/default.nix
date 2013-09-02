{ cabal, ansiTerminal, mtl, optparseApplicative, regexPosix, stm
, tagged
}:

cabal.mkDerivation (self: {
  pname = "tasty";
  version = "0.3";
  sha256 = "0sgc0529sqhj0b75a4mkdw0bkx56ynyl4msmi8hd20jvv5wnzyi6";
  buildDepends = [
    ansiTerminal mtl optparseApplicative regexPosix stm tagged
  ];
  meta = {
    description = "Modern and extensible testing framework";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
