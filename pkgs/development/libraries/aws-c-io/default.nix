{ lib, stdenv, fetchFromGitHub, cmake, aws-c-cal, aws-c-common, s2n }:

stdenv.mkDerivation rec {
  pname = "aws-c-io";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-dDvq5clOUaPR7lOCJ/1g0lrCzVOmzwCnqHrBZfBewO4=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ aws-c-cal aws-c-common s2n ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DCMAKE_MODULE_PATH=${aws-c-common}/lib/cmake"
  ];

  NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-Wno-error";

  meta = with lib; {
    description = "AWS SDK for C module for IO and TLS";
    homepage = "https://github.com/awslabs/aws-c-io";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ orivej ];
  };
}
