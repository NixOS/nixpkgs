{cabal, monadControl, stm, transformers}:

cabal.mkDerivation (self : {
  pname = "pool";
  version = "0.1.0.2";
  sha256 = "1w2z3p3iriw43g655rhd5b70r3cbzl4jf8bybyk5d04x6mcg3wfq";
  propagatedBuildInputs = [monadControl stm transformers];
  meta = {
    description = "Thread-safe resource pools";
    license = "BSD3";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})

