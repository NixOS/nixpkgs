{ cabal, conduit, filepath, hspec, stm, time, transformers }:

cabal.mkDerivation (self: {
  pname = "unix-process-conduit";
  version = "0.2.1.1";
  sha256 = "038z99gzwqhig65zzb3hc9zisnvzslvvy86wjgx6wz90p6vbxzn4";
  buildDepends = [ conduit filepath stm time transformers ];
  testDepends = [ conduit hspec transformers ];
  meta = {
    homepage = "https://github.com/snoyberg/conduit";
    description = "Run processes on Unix systems, with a conduit interface";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
