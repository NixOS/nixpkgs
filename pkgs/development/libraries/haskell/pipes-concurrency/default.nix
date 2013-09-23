{ cabal, async, pipes, stm }:

cabal.mkDerivation (self: {
  pname = "pipes-concurrency";
  version = "2.0.1";
  sha256 = "0grfwmmwzxrska2218php22f898nn3x92bz1lmhpw2qi8mywvkzh";
  buildDepends = [ pipes stm ];
  testDepends = [ async pipes stm ];
  meta = {
    description = "Concurrency for the pipes ecosystem";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
