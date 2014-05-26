{ cabal, binary, digest, filepath, HUnit, mtl, text, time, zlib }:

cabal.mkDerivation (self: {
  pname = "zip-archive";
  version = "0.2.3.2";
  sha256 = "1y69sk6jyw1klgpl6bcamq1i9wy1536hz9x4s9b8n375sbhj10f1";
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
