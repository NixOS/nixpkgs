{ cabal, binary, digest, filepath, HUnit, mtl, time, utf8String
, zlib
}:

cabal.mkDerivation (self: {
  pname = "zip-archive";
  version = "0.1.4";
  sha256 = "0ipk8gwa2k8iqg2gg4lbawr8l9sjwhy2p7b8qxazpq0i88dyy3lb";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ binary digest filepath mtl time utf8String zlib ];
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
