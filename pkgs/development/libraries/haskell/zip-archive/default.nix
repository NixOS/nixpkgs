{cabal, binary, mtl, utf8String, zlib, digest}:

cabal.mkDerivation (self : {
  pname = "zip-archive";
  version = "0.1.1.3";
  sha256 = "2caa3e6020c394c740b942685306c71e91bebf6e499627dc20fdf0ac7925a57a";
  propagatedBuildInputs = [binary mtl utf8String zlib digest];
  meta = {
    description = "Library for creating and modifying zip archives";
  };
})  

