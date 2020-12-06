{ lib, stdenv, fetchFromGitHub, cmake, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "aws-checksums";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "0am1hfzqir44zcx6y6c7jw74qvbsav8ppr9dahpdh3ac95cjf38a";
  };

  nativeBuildInputs = [ cmake ];

  # can be removed once https://github.com/awslabs/aws-checksums/pull/40 gets merged, and version bumped
  patches = [
    (fetchpatch {
      url = "https://github.com/awslabs/aws-checksums/pull/40/commits/fb5a57b3c072bd88e45de76fbb76bdc89c67b193.patch";
      sha256 = "056f9kyg1c4lwjq8n0r28w1n3zbwrwpi1wbqabk99gaayg46x35a";
    })
  ];

  cmakeFlags = [ "-DBUILD_SHARED_LIBS:BOOL=ON" ];

  meta = with lib; {
    description = "HW accelerated CRC32c and CRC32";
    homepage = "https://github.com/awslabs/aws-checksums";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ orivej eelco ];
  };
}
