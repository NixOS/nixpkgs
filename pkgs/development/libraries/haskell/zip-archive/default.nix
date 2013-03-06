{ cabal, binary, digest, filepath, HUnit, mtl, time, utf8String
, zlib
}:

cabal.mkDerivation (self: {
  pname = "zip-archive";
  version = "0.1.3.4";
  sha256 = "0hvndr3gb7fiv4qjwjvic5mg7wq7h7nw3c3v5xq8fnlr1l943vyb";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ binary digest filepath mtl time utf8String zlib ];
  testDepends = [ HUnit time ];
  meta = {
    homepage = "http://github.com/jgm/zip-archive";
    description = "Library for creating and modifying zip archives";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
