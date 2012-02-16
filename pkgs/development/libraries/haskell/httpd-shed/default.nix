{ cabal, network }:

cabal.mkDerivation (self: {
  pname = "httpd-shed";
  version = "0.4";
  sha256 = "c03f784742bdc3053c7e867e587ee859a9a3adaa082d36bdb2ea69da1b02069f";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ network ];
  meta = {
    description = "A simple web-server with an interact style API";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
