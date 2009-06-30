{cabal, zlib}:

cabal.mkDerivation (self : {
  pname = "digest";
  version = "0.0.0.5";
  sha256 = "dddfcdd325dc7d4fb1ce4772c1f5618cb20504b28dba8a78682011cba1341efd";
  propagatedBuildInputs = [zlib];
  meta = {
    description = "Various cryptographic hashes for bytestrings: CRC32 and Adler32 for now";
  };
})  

