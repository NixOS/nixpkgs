{ cabal, conduit, hspec, HUnit, network, networkConduit }:

cabal.mkDerivation (self: {
  pname = "simple-sendfile";
  version = "0.2.13";
  sha256 = "03cgbzfhkih1ln1xb78r1hfh6zzjjj6763n9nzr9cj6bxs0fiqd3";
  buildDepends = [ network ];
  testDepends = [ conduit hspec HUnit network networkConduit ];
  doCheck = false;
  meta = {
    description = "Cross platform library for the sendfile system call";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
