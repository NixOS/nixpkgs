{ stdenv, fetchurl, openssl }:

stdenv.mkDerivation {
  name = "fastpbkdf2-1.0.0";
  
  src = fetchurl {
    url = https://github.com/ctz/fastpbkdf2/archive/v1.0.0.tar.gz;
    sha256 = "492874e2088dd38cfa74b1b3a99c0b907ecb8da96c656e618353a2e825b8c152";
  };
  
  buildInputs = [ openssl ];

  preBuild = ''
    makeFlagsArray=(CFLAGS="-std=c99 -O3 -g")
  '';

  installPhase = ''
    mkdir -p $out/{lib,include/fastpbkdf2}
    cp *.a $out/lib
    cp fastpbkdf2.h $out/include/fastpbkdf2
  '';

  meta = with stdenv.lib; {
    description = "A fast PBKDF2-HMAC-{SHA1,SHA256,SHA512} implementation in C";
    homepage = https://github.com/ctz/fastpbkdf2;
    licenses = licenses.cc0;
    maintainers = with maintainers; [ ledif ];
  };
}
