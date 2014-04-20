{ cabal, aeson, attoparsecEnumerator, dataDefault, deepseq
, filepath, hashable, MonadCatchIOTransformers, network, safe
, snapCore, snapServer, stm, text, time, transformers
, unorderedContainers, utf8String, vault, websockets
, websocketsSnap
}:

cabal.mkDerivation (self: {
  pname = "threepenny-gui";
  version = "0.4.1.0";
  sha256 = "0fafwnlbl96z9m5fr3wiyv090fga78cr9hrd4yd3vyiz44gfrpcw";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson attoparsecEnumerator dataDefault deepseq filepath hashable
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
