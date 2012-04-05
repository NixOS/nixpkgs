{ cabal, enumerator, transformers, zlibBindings }:

cabal.mkDerivation (self: {
  pname = "zlib-enum";
  version = "0.2.2";
  sha256 = "1fmlvjj1krigj5aqipq5pf0mqnybr7zz50mgqr30kznfg48ry29y";
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
