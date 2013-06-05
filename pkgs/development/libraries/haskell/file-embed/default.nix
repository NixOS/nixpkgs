{ cabal, filepath, HUnit }:

cabal.mkDerivation (self: {
  pname = "file-embed";
  version = "0.0.4.8";
  sha256 = "1jq4jdrxw822gzz7mc07nx4yj233mwmykp6xk371pf3hnq8rly0h";
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
