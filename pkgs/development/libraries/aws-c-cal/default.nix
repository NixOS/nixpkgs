{ lib, stdenv, fetchFromGitHub, cmake, aws-c-common, nix, openssl, Security }:

stdenv.mkDerivation rec {
  pname = "aws-c-cal";
<<<<<<< HEAD
  version = "0.6.0";
=======
  version = "0.5.21";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-qsYQViMto5j6piCg6gBjzFfPJlLkJt4949o217QsV6Q=";
=======
    sha256 = "sha256-WMCLVwRrgwFsaqoKtbQNt0bHVYi1LUZt5r0i3oAfWFE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ aws-c-common openssl ];

  propagatedBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ Security ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
  ];

  passthru.tests = {
    inherit nix;
  };

  meta = with lib; {
    description = "AWS Crypto Abstraction Layer ";
    homepage = "https://github.com/awslabs/aws-c-cal";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ orivej ];
  };
}
