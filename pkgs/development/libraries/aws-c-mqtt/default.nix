{ lib, stdenv
, fetchFromGitHub
, aws-c-cal
, aws-c-common
, aws-c-compression
, aws-c-http
, aws-c-io
, cmake
, s2n-tls
}:

stdenv.mkDerivation rec {
  pname = "aws-c-mqtt";
  version = "0.7.11";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "aws-c-mqtt";
    rev = "v${version}";
    sha256 = "sha256-+vxn9Fq8eZ53cRR31hnLf1cxZ2zY03lt2RuEop+ciu0=";
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

  meta = with lib; {
    description = "C99 implementation of the MQTT 3.1.1 specification";
    homepage = "https://github.com/awslabs/aws-c-mqtt";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ r-burns ];
  };
}
