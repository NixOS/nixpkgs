{ cabal, extensibleExceptions, mtl, network, parsec, xhtml }:

cabal.mkDerivation (self: {
  pname = "cgi";
  version = "3001.1.7.3";
  sha256 = "f1f4bc6b06e8a191db4ddb43617fee3ef37635e380d6a17c29efb5641ce91df0";
  buildDepends = [ extensibleExceptions mtl network parsec xhtml ];
  meta = {
    homepage = "http://andersk.mit.edu/haskell/cgi/";
    description = "A library for writing CGI programs";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
