{ cabal, stm }:

cabal.mkDerivation (self: {
  pname = "stm-chans";
  version = "1.3.1";
  sha256 = "15agd0d3r3zmya72hpi9pkmzqw7mj6l84946dhds0hsb6d12r6qj";
  buildDepends = [ stm ];
  meta = {
    homepage = "http://code.haskell.org/~wren/";
    description = "Additional types of channels for STM";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
