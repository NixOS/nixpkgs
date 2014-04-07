{ cabal, exceptions, extensibleExceptions, filepath, ghcMtl
, ghcPaths, HUnit, mtl, random, utf8String
}:

cabal.mkDerivation (self: {
  pname = "hint";
  version = "0.4.1.0";
  sha256 = "1hc66yfzg9jrm5h3hd52rm4ca8ha0j93rhjpjh6hhzr4a40jv0pl";
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
