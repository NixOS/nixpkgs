{ cabal, hspec, QuickCheck, zlib }:

cabal.mkDerivation (self: {
  pname = "zlib-bindings";
  version = "0.1.1.3";
  sha256 = "18jhav7chbapakm9mwn7bn9lgvip7qaz61dw5gwv2nyalvm96qfr";
  buildDepends = [ zlib ];
  testDepends = [ hspec QuickCheck zlib ];
  meta = {
    homepage = "http://github.com/snoyberg/zlib-bindings";
    description = "Low-level bindings to the zlib package";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
