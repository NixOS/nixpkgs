{ cabal }:

cabal.mkDerivation (self: {
  pname = "template-haskell";
  version = "2.8.0.0";
  sha256 = "1c75f7d0zhdh84za42dk0qkh9s9v29s4zzfy7aincq4dwjaa3rpc";
  meta = {
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
