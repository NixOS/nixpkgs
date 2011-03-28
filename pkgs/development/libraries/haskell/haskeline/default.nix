{cabal, extensibleExceptions, mtl, utf8String}:

cabal.mkDerivation (self : {
  pname = "haskeline";
  version = "0.6.3.2";
  sha256 = "0ragimzrilsk5r8n0fbq3lyjww28bmc1r1vgjf9pb4kpfpbz0cq8";
  propagatedBuildInputs = [extensibleExceptions mtl utf8String];
  meta = {
    description = "A command-line interface for user input, written in Haskell";
  };
})

