{ cabal, filepath, hslogger, MissingH, mtl, regexBase, regexCompat
, regexPosix
}:

cabal.mkDerivation (self: {
  pname = "HSH";
  version = "2.0.3";
  sha256 = "10ndmzwaf9by8wnawl3p1r7wn6hqigfymv7hd99ayf25dsqwnzx2";
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
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
