{cabal, mtl, zlib, mmap}:

cabal.mkDerivation (self : {
  pname = "hashed-storage";
  version = "0.3.8";
  sha256 = "1f379dcb00a56c0b330eeabb1f069ef294bcf1f3dc18980e93b8b228e577fdb1";
  propagatedBuildInputs = [mtl zlib mmap];
  meta = {
    description = "Hashed file storage support code";
  };
})  

