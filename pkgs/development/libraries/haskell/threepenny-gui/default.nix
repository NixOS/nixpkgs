{ cabal, attoparsecEnumerator, dataDefault, deepseq, filepath
, hashable, json, MonadCatchIOTransformers, network, safe, snapCore
, snapServer, stm, text, time, transformers, unorderedContainers
, utf8String, vault, websockets, websocketsSnap
}:

cabal.mkDerivation (self: {
  pname = "threepenny-gui";
  version = "0.4.0.1";
  sha256 = "18ahfcbzlp0k5ry9fdzdv8jdwv10iplnbbnh2xyr3cqils2yp68m";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    attoparsecEnumerator dataDefault deepseq filepath hashable json
    MonadCatchIOTransformers network safe snapCore snapServer stm text
    time transformers unorderedContainers utf8String vault websockets
    websocketsSnap
  ];
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/Threepenny-gui";
    description = "GUI framework that uses the web browser as a display";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
