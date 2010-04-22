{cabal, binary, mtl, utf8String, zlib, digest}:

cabal.mkDerivation (self : {
  pname = "zip-archive";
  version = "0.1.1.6";
  sha256 = "16aafc5f74c880398413a7c2adaaf90cae86006dcda58f663c1e1d795add90aa";
  propagatedBuildInputs = [binary mtl utf8String zlib digest];
  meta = {
    description = "Library for creating and modifying zip archives";
  };
})  

