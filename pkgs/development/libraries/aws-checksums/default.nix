{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "aws-checksums";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "1s6zwf97rkkvnf3p7vlaykwa4pxpvj78pmxvvjf5jk29f93b49xp";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "HW accelerated CRC32c and CRC32";
    homepage = https://github.com/awslabs/aws-checksums;
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ orivej eelco ];
  };
}
