{ cabal, attoparsecEnumerator, dataDefault, deepseq, filepath
, hashable, json, MonadCatchIOTransformers, network, safe, snapCore
, snapServer, stm, text, time, transformers, unorderedContainers
, utf8String, vault, websockets, websocketsSnap
}:

cabal.mkDerivation (self: {
  pname = "threepenny-gui";
  version = "0.4.0.2";
  sha256 = "0dx6jrpxvd6ypz314hmq8nngy0wjx3bwx3r9h1c6y70id31lr9pg";
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
