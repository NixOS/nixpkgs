{ cabal, filepath, HUnit }:

cabal.mkDerivation (self: {
  pname = "file-embed";
  version = "0.0.7";
  sha256 = "0mj8f70f9k78wjzcx59w68szajafmm119rcrsspmxsygglh8ji2g";
  buildDepends = [ filepath ];
  testDepends = [ filepath HUnit ];
  meta = {
    homepage = "https://github.com/snoyberg/file-embed";
    description = "Use Template Haskell to embed file contents directly";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
