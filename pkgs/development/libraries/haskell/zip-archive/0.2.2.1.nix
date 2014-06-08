{ cabal, binary, digest, filepath, HUnit, mtl, text, time, zlib }:

cabal.mkDerivation (self: {
  pname = "zip-archive";
  version = "0.2.2.1";
  sha256 = "0w9l3kdlwkc3yvyxb152s9qwzmc0kjp6d1cbk7yfkpw3081qgckn";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ binary digest filepath mtl text time zlib ];
  testDepends = [ HUnit time ];
  doCheck = false;
  meta = {
    homepage = "http://github.com/jgm/zip-archive";
    description = "Library for creating and modifying zip archives";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
