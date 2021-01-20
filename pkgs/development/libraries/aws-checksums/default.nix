{ lib, stdenv, fetchFromGitHub, cmake, aws-c-common }:

stdenv.mkDerivation rec {
  pname = "aws-checksums";
  version = "0.1.10";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "1f9scl5734pgjlsixspwljrrlndzhllwlfygdcr1gx5p0za08zjb";
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
