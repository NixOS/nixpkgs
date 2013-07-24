{ cabal, filepath, transformers }:

cabal.mkDerivation (self: {
  pname = "cmdargs";
  version = "0.10.4";
  sha256 = "0y8jmpm31z7dd02xa6b5i6gpdjb6pz4pg7m5wbqff7fhbipf0lk0";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ filepath transformers ];
  meta = {
    homepage = "http://community.haskell.org/~ndm/cmdargs/";
    description = "Command line argument processing";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
