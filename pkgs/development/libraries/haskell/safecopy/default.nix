{ cabal, cereal, text }:

cabal.mkDerivation (self: {
  pname = "safecopy";
  version = "0.8.2";
  sha256 = "0l2kqymsxv244fahxcpxlrspk6xipz3br6j854ipbfh8b0bfvr4m";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    cereal text
  ];
  meta = {
    homepage = "http://acid-state.seize.it/safecopy";
    description = "Binary serialization with version control.";
    license = self.stdenv.lib.licenses.publicDomain;
    platforms = self.ghc.meta.platforms;
    maintainers = [
    ];
  };
})
