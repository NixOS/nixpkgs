{ cabal, cmdtheline, filepath, haskeline, monadUnify, mtl, parsec
, patternArrows, time, transformers, unorderedContainers
, utf8String, xdgBasedir
}:

cabal.mkDerivation (self: {
  pname = "purescript";
  version = "0.5.2.2";
  sha256 = "07gkd897qcgn7yf81bii5njkiq1hlhfz5jx3spdlv64a492grmg2";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    cmdtheline filepath haskeline monadUnify mtl parsec patternArrows
    time transformers unorderedContainers utf8String xdgBasedir
  ];
  testDepends = [ filepath mtl parsec transformers utf8String ];
  doCheck = false;
  meta = {
    homepage = "http://www.purescript.org/";
    description = "PureScript Programming Language Compiler";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
