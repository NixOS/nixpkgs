{ cabal, text }:

cabal.mkDerivation (self: {
  pname = "hflags";
  version = "0.3";
  sha256 = "113pqdjnxfhkk95969ia393n1jvbbnfljsz42vfapgzvd8f1fci2";
  buildDepends = [ text ];
  meta = {
    homepage = "http://github.com/errge/hflags";
    description = "Command line flag parser, very similar to Google's gflags";
    license = "Apache-2.0";
    platforms = self.ghc.meta.platforms;
  };
})
