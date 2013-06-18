{ cabal, text }:

cabal.mkDerivation (self: {
  pname = "hflags";
  version = "0.1.3";
  sha256 = "0nn08xqn0hvdlblnaad3nsdfkc0ssab6kvhi4qbrcq9jmjmspld3";
  buildDepends = [ text ];
  meta = {
    homepage = "http://github.com/errge/hflags";
    description = "Command line flag parser, very similar to Google's gflags";
    license = "Apache-2.0";
    platforms = self.ghc.meta.platforms;
  };
})
