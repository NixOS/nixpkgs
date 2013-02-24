{ cabal, filepath, HUnit }:

cabal.mkDerivation (self: {
  pname = "file-embed";
  version = "0.0.4.7";
  sha256 = "1hn08499kay0y6ik5z1s58s8r9h1nzf116avgi6ia4b565wpzkvi";
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
