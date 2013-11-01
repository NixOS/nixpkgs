{ cabal, filepath, HUnit }:

cabal.mkDerivation (self: {
  pname = "file-embed";
  version = "0.0.5";
  sha256 = "0s77g7azw73f7d07hvwwps8sx79jpwj8ap9iqzcglyjw1sw4l1n1";
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
