{ lib
, stdenv
, aws-c-cal
, aws-c-common
, aws-c-compression
, aws-c-http
, aws-c-io
, cmake
, fetchFromGitHub
, nix
, s2n-tls
}:

stdenv.mkDerivation rec {
  pname = "aws-c-mqtt";
  version = "0.9.7";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "aws-c-mqtt";
    rev = "refs/tags/v${version}";
    hash = "sha256-5I9tQ/KGy6hulzc3ZWclDRP3gCvRDWR91YVqrGbt6hA=";
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

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
  ];

  passthru.tests = {
    inherit nix;
  };

  meta = with lib; {
    description = "C99 implementation of the MQTT 3.1.1 specification";
    homepage = "https://github.com/awslabs/aws-c-mqtt";
    changelog = "https://github.com/awslabs/aws-c-mqtt/releases/tag/v${version}";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ r-burns ];
  };
}
