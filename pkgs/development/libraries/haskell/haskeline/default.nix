{cabal, extensibleExceptions, mtl, utf8String}:

cabal.mkDerivation (self : {
  pname = "haskeline";
  version = "0.6.1.3";
  sha256 = "af27d17bf6df7647e843bca91548b542748a5305f072ba7cfef97105a52578d4";
  propagatedBuildInputs = [extensibleExceptions mtl utf8String];
  meta = {
    description = "A command-line interface for user input, written in Haskell";
  };
})  

