{ cabal, stm }:

cabal.mkDerivation (self: {
  pname = "stm-chans";
  version = "2.0.0";
  sha256 = "041dmjmr70was4vxf1ihizzarms7a8x53m80i65ggxxmq5xqmsa3";
  buildDepends = [ stm ];
  meta = {
    homepage = "http://code.haskell.org/~wren/";
    description = "Additional types of channels for STM";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
