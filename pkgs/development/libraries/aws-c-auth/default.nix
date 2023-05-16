{ lib
, stdenv
, fetchFromGitHub
, aws-c-cal
, aws-c-common
, aws-c-compression
, aws-c-http
, aws-c-io
, aws-c-sdkutils
, cmake
, nix
, s2n-tls
}:

stdenv.mkDerivation rec {
  pname = "aws-c-auth";
<<<<<<< HEAD
  version = "0.7.0";
=======
  version = "0.6.26";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "aws-c-auth";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-DzUobQ8qZNb83CwVKK9E1V51uHHo22nlBGKdN55W7UY=";
=======
    sha256 = "sha256-PvdkTw5JydJT0TbXLB2C9tk4T+ho+fAbaw4jU9m5KuU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    aws-c-cal
    aws-c-common
    aws-c-compression
    aws-c-http
    aws-c-io
    s2n-tls
  ];

  propagatedBuildInputs = [
    aws-c-sdkutils
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
  ];

  passthru.tests = {
    inherit nix;
  };

  meta = with lib; {
    description = "C99 library implementation of AWS client-side authentication";
    homepage = "https://github.com/awslabs/aws-c-auth";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ r-burns ];
  };
}
