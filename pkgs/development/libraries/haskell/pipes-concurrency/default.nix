{ cabal, async, pipes, stm }:

cabal.mkDerivation (self: {
  pname = "pipes-concurrency";
  version = "2.0.2";
  sha256 = "0g4fbh8dk8ph2ga0vyanqj52rxk9c1zi6g4yk3a1g6bnf4bklhm8";
  buildDepends = [ pipes stm ];
  testDepends = [ async pipes stm ];
  meta = {
    description = "Concurrency for the pipes ecosystem";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
