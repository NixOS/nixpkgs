{cabal, extensibleExceptions, mtl, utf8String}:

cabal.mkDerivation (self : {
  pname = "haskeline";
  version = "0.6.2.2";
  sha256 = "b6307563258802453d65c7e7bd1ef1c6635fefea17af3e01449192b52075b25b";
  propagatedBuildInputs = [extensibleExceptions mtl utf8String];
  meta = {
    description = "A command-line interface for user input, written in Haskell";
  };
})  

