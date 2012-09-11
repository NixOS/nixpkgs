{ cabal }:

cabal.mkDerivation (self: {
  pname = "file-embed";
  version = "0.0.4.5";
  sha256 = "18rhcjll5gj790g5balk3xhnmmgjh2bixik8vna5drs7y9i0innp";
  meta = {
    homepage = "https://github.com/snoyberg/file-embed";
    description = "Use Template Haskell to embed file contents directly";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
