{ cabal, stm }:

cabal.mkDerivation (self: {
  pname = "stm-chans";
  version = "3.0.0";
  sha256 = "1nnl5h88dshcmk0ydhkf84kkf6989igxry9r0z7lwlxfgf7q9nim";
  buildDepends = [ stm ];
  meta = {
    homepage = "http://code.haskell.org/~wren/";
    description = "Additional types of channels for STM";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
