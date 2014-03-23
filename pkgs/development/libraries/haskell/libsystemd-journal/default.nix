{ cabal, hashable, hsyslog, pipes, pipesSafe, systemd-journal, text
, transformers, uniplate, unixBytestring, unorderedContainers, uuid
, vector
}:

cabal.mkDerivation (self: {
  pname = "libsystemd-journal";
  version = "1.1.0";
  sha256 = "0zdql5y40d0d044mwbsr3xxmfzgnnp02a36wbbslxmrm5c3w1qi2";
  buildDepends = [
    hashable hsyslog pipes pipesSafe text transformers uniplate
    unixBytestring unorderedContainers uuid vector
  ];
  extraLibraries = [ systemd-journal ];
  meta = {
    homepage = "http://github.com/ocharles/libsystemd-journal";
    description = "Haskell bindings to libsystemd-journal";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
