{ cabal, enumerator, transformers }:

cabal.mkDerivation (self: {
  pname = "yaml";
  version = "0.4.1.2";
  sha256 = "1c7ffs5gkwk0l0vg7amsflra1j8ifd9cvvbqx9jzkqsay8hbr4vb";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ enumerator transformers ];
  meta = {
    homepage = "http://github.com/snoyberg/yaml/";
    description = "Low-level binding to the libyaml C library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
