{ lib, stdenv, fetchFromGitHub, cmake, aws-c-common }:

stdenv.mkDerivation rec {
  pname = "aws-checksums";
  version = "0.1.11";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-fXu7GI2UR9QiBGP2n2pEFRjz9ZwA+BAK9zxhNnoYWt4=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ aws-c-common ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DCMAKE_MODULE_PATH=${aws-c-common}/lib/cmake"
  ];

  meta = with lib; {
    description = "HW accelerated CRC32c and CRC32";
    homepage = "https://github.com/awslabs/aws-checksums";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ orivej eelco ];
  };
}
