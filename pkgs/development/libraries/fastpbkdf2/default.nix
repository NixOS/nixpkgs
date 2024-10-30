{ lib, stdenv, fetchFromGitHub, openssl }:

stdenv.mkDerivation rec {
  pname = "fastpbkdf2";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "ctz";
    repo = "fastpbkdf2";
    rev = "v${version}";
    sha256 = "09ax0h4ik3vhvp3s98lic93l3g9f4v1jkr5k6z4g1lvm7s3lrha2";
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

  meta = with lib; {
    description = "Fast PBKDF2-HMAC-{SHA1,SHA256,SHA512} implementation in C";
    homepage = "https://github.com/ctz/fastpbkdf2";
    license = licenses.cc0;
    maintainers = with maintainers; [ ledif ];
  };
}
