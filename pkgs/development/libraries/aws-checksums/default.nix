{ lib, stdenv, fetchFromGitHub, cmake, aws-c-common, nix }:

stdenv.mkDerivation rec {
  pname = "aws-checksums";
<<<<<<< HEAD
  version = "0.1.17";
=======
  version = "0.1.14";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-OoEwubEEkLJmlqmQR4/rp4+b1WYJEbcjYDSdXXHleZQ=";
=======
    sha256 = "sha256-yoViXJuM9UQMcn8W0CcWkCXroBLXjAestr+oqWHi5hQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ aws-c-common ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
  ];

  passthru.tests = {
    inherit nix;
  };

  meta = with lib; {
    description = "HW accelerated CRC32c and CRC32";
    homepage = "https://github.com/awslabs/aws-checksums";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ orivej eelco ];
  };
}
