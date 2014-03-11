{ cabal, exceptions, extensibleExceptions, filepath, ghcMtl
, ghcPaths, HUnit, mtl, random, utf8String
}:

cabal.mkDerivation (self: {
  pname = "hint";
  version = "0.4.0.0";
  sha256 = "0xs56ws7vwdjgvg7d31iqa111342an6rxvwhh7c3h4z1bq5l1l61";
  buildDepends = [
    exceptions extensibleExceptions filepath ghcMtl ghcPaths mtl random
    utf8String
  ];
  testDepends = [
    exceptions extensibleExceptions filepath HUnit mtl
  ];
  meta = {
    homepage = "http://hub.darcs.net/jcpetruzza/hint";
    description = "Runtime Haskell interpreter (GHC API wrapper)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
