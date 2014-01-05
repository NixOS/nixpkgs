{ cabal, conduit, filepath, hspec, stm, time, transformers }:

cabal.mkDerivation (self: {
  pname = "unix-process-conduit";
  version = "0.2.2.2";
  sha256 = "0an4lwwkzr902r0rxa35i9kdm5cpgdfmg5m06zsxzbck3mry7871";
  buildDepends = [ conduit filepath stm time transformers ];
  testDepends = [ conduit hspec transformers ];
  meta = {
    homepage = "https://github.com/snoyberg/conduit";
    description = "Run processes on Unix systems, with a conduit interface";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
