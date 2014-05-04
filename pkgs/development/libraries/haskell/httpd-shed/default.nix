{ cabal, network }:

cabal.mkDerivation (self: {
  pname = "httpd-shed";
  version = "0.4.0.1";
  sha256 = "04m07wqhaggkgksha7x528y890j30ay5axipfy6b1ma9cf0a9jwq";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ network ];
  jailbreak = true;
  meta = {
    description = "A simple web-server with an interact style API";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
