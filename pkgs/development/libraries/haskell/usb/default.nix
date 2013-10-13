{ cabal, baseUnicodeSymbols, bindingsLibusb, text, vector }:

cabal.mkDerivation (self: {
  pname = "usb";
  version = "1.2";
  sha256 = "1k73avkmpbmg6iq2kmwhg2ifibni5c1yp202afdb6v7w5akvmc0b";
  buildDepends = [ baseUnicodeSymbols bindingsLibusb text vector ];
  meta = {
    homepage = "http://basvandijk.github.com/usb";
    description = "Communicate with USB devices";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
