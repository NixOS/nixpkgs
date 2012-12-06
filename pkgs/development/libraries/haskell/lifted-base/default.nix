{ cabal, baseUnicodeSymbols, monadControl, transformersBase }:

cabal.mkDerivation (self: {
  pname = "lifted-base";
  version = "0.2.0.1";
  sha256 = "0ffv6zjddq9nga8m3m737chznph2z12mpgfs097aq0sgbmx6df6z";
  buildDepends = [
    baseUnicodeSymbols monadControl transformersBase
  ];
  meta = {
    homepage = "https://github.com/basvandijk/lifted-base";
    description = "lifted IO operations from the base library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
