{ cabal, Cabal, extensibleExceptions, filepath, hint, mtl, show
, simpleReflect, utf8String
}:

cabal.mkDerivation (self: {
  pname = "mueval";
  version = "0.9.1";
  sha256 = "1f668z7rpdj2m239f5i54v7kd7wsvx3qvvhwyiavf28cmk32mxpq";
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
