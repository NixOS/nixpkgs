{ cabal, filepath, hslogger, MissingH, mtl, regexBase, regexCompat
, regexPosix
}:

cabal.mkDerivation (self: {
  pname = "HSH";
  version = "2.0.4";
  sha256 = "1ddpazmk82716hqd1riqs7vnl4aildgwkjgk80iam49df9p5b8v8";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    filepath hslogger MissingH mtl regexBase regexCompat regexPosix
  ];
  meta = {
    homepage = "http://software.complete.org/hsh";
    description = "Library to mix shell scripting with Haskell programs";
    license = "LGPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
