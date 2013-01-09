{ cabal, binary, digest, filepath, mtl, time, utf8String, zlib }:

cabal.mkDerivation (self: {
  pname = "zip-archive";
  version = "0.1.3.3";
  sha256 = "0zzps6s6lsv35qv1xx1fwipk2nwv255wpa956mvzbwdr47pgqjwi";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ binary digest filepath mtl time utf8String zlib ];
  meta = {
    homepage = "http://github.com/jgm/zip-archive";
    description = "Library for creating and modifying zip archives";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
