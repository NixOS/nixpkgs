{ cabal }:

cabal.mkDerivation (self: {
  pname = "file-embed";
  version = "0.0.4.6";
  sha256 = "0p2vs56s1jy5xaw3axzfsir925z2a46624n32x797lga9khm3qvp";
  meta = {
    homepage = "https://github.com/snoyberg/file-embed";
    description = "Use Template Haskell to embed file contents directly";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
