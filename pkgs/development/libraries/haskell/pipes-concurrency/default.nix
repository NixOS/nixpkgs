{ cabal, async, pipes, stm }:

cabal.mkDerivation (self: {
  pname = "pipes-concurrency";
  version = "2.0.0";
  sha256 = "1f9l6qlaf8dyldzwaavj3k5akm74ycga5j173ypdna3pv0jbzfrk";
  buildDepends = [ pipes stm ];
  testDepends = [ async pipes stm ];
  meta = {
    description = "Concurrency for the pipes ecosystem";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
