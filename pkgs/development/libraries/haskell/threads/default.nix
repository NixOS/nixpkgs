{ cabal, baseUnicodeSymbols, stm }:

cabal.mkDerivation (self: {
  pname = "threads";
  version = "0.5.0.1";
  sha256 = "0amyaxa70q6v021nab6v3cfqc40mwj5dr2fwla9d4bm6ppmq6lyy";
  buildDepends = [ baseUnicodeSymbols stm ];
  meta = {
    homepage = "https://github.com/basvandijk/threads";
    description = "Fork threads and wait for their result";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
