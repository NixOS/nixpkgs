{ cabal, filepath, HUnit }:

cabal.mkDerivation (self: {
  pname = "file-embed";
  version = "0.0.4.9";
  sha256 = "128z3jwxn6d13dkrfjx7maxgmax8bfgr8n2jfhqg3rvv4ryjnqv2";
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
