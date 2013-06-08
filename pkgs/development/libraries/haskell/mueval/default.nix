{ cabal, Cabal, extensibleExceptions, filepath, hint, mtl, show
, simpleReflect, utf8String
}:

cabal.mkDerivation (self: {
  pname = "mueval";
  version = "0.9";
  sha256 = "1y6n3zvdlzxl5hi1raz7ac6fgy9321ilka3g2pk7p1ss9d10k8pb";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    Cabal extensibleExceptions filepath hint mtl show simpleReflect
    utf8String
  ];
  meta = {
    homepage = "http://code.haskell.org/mubot/";
    description = "Safely evaluate pure Haskell expressions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
