{ cabal, enumerator, transformers, zlibBindings }:

cabal.mkDerivation (self: {
  pname = "zlib-enum";
  version = "0.2.2.1";
  sha256 = "02ava6h40bqfmby33683nxasfw5fmrgfvbx6kqgz1gqz5921gjx9";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ enumerator transformers zlibBindings ];
  meta = {
    homepage = "http://github.com/maltem/zlib-enum";
    description = "Enumerator interface for zlib compression";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
