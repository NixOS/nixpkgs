{ cabal, cmdtheline, filepath, haskeline, monadUnify, mtl, parsec
, patternArrows, time, transformers, unorderedContainers
, utf8String, xdgBasedir
}:

cabal.mkDerivation (self: {
  pname = "purescript";
  version = "0.5.2.6";
  sha256 = "0aszzaj3942xgq0nmql68s5cgplhkqrk0k6cfd1mx5lq5n0qxf94";
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
