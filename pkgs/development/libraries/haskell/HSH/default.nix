{ cabal, filepath, hslogger, MissingH, mtl, regexBase, regexCompat
, regexPosix, fetchurl
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
  patches = [ (fetchurl { url = "https://github.com/jgoerzen/hsh/pull/10.patch"; sha256 = "0fw2ihl4hlncggwf3v4d7aydm3rzgzpcxplfbwq7janysix4q950"; }) ];
  meta = {
    homepage = "http://software.complete.org/hsh";
    description = "Library to mix shell scripting with Haskell programs";
    license = "LGPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
