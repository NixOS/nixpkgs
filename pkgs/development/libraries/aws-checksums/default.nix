{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "aws-checksums";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "1r21sfs1ik6cb8bz17w6gp6y2xa9rbjxjka0p6airb3qds094iv5";
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
