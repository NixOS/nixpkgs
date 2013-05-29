{ cabal, enumerator, transformers, zlibBindings }:

cabal.mkDerivation (self: {
  pname = "zlib-enum";
  version = "0.2.3";
  sha256 = "0lr72h4wlclav0p0j5wwaxifq97lw7rh3612lva73fg45akl9di1";
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
