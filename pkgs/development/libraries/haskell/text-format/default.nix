{ cabal, doubleConversion, text, time, transformers }:

cabal.mkDerivation (self: {
  pname = "text-format";
  version = "0.3.1.1";
  sha256 = "02zfgzfjvkaxbma1h2gr95h10c8q9gyaadag41q579j68iv15qbd";
  buildDepends = [ doubleConversion text time transformers ];
  meta = {
    homepage = "https://github.com/bos/text-format";
    description = "Text formatting";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
