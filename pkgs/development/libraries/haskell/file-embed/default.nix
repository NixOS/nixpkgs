{ cabal }:

cabal.mkDerivation (self: {
  pname = "file-embed";
  version = "0.0.4.2";
  sha256 = "1nismycqm8shh6zgjjfysc0yhn5yrcdvw23k6adzizawsvr92bkw";
  meta = {
    homepage = "http://github.com/snoyberg/file-embed/tree/master";
    description = "Use Template Haskell to embed file contents directly";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
