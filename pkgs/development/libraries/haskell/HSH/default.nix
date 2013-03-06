{ cabal, filepath, hslogger, MissingH, mtl, regexBase, regexCompat
, regexPosix
}:

cabal.mkDerivation (self: {
  pname = "HSH";
  version = "2.1.0";
  sha256 = "0gz2hzdvf0gqv33jihn67bvry38c6hkjapb1prxmb3w12lisr4l5";
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
