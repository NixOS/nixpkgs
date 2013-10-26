{ cabal, doubleConversion, text, time, transformers }:

cabal.mkDerivation (self: {
  pname = "text-format";
  version = "0.3.1.0";
  sha256 = "13k5a1kfmapd4yckm2vcrwz4vrrf32c2dpisdw0hyvzvmdib3n60";
  buildDepends = [ doubleConversion text time transformers ];
  meta = {
    homepage = "https://github.com/bos/text-format";
    description = "Text formatting";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
