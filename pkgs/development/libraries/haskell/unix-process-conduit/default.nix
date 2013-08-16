{ cabal, conduit, filepath, hspec, stm, time, transformers }:

cabal.mkDerivation (self: {
  pname = "unix-process-conduit";
  version = "0.2.2";
  sha256 = "15n6n925avv51kr2avwkp8sq8mfl287i0445vl9iy6hyxjjgpgr6";
  buildDepends = [ conduit filepath stm time transformers ];
  testDepends = [ conduit hspec transformers ];
  meta = {
    homepage = "https://github.com/snoyberg/conduit";
    description = "Run processes on Unix systems, with a conduit interface";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
