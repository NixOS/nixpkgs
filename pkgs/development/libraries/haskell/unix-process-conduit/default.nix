{ cabal, conduit, filepath, hspec, stm, time, transformers }:

cabal.mkDerivation (self: {
  pname = "unix-process-conduit";
  version = "0.2.1.2";
  sha256 = "1gg1ynqd8hka5ynpmpsj8qw0lqsyg7l1m1py05iw3bd3cldwflx1";
  buildDepends = [ conduit filepath stm time transformers ];
  testDepends = [ conduit hspec transformers ];
  meta = {
    homepage = "https://github.com/snoyberg/conduit";
    description = "Run processes on Unix systems, with a conduit interface";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
