{ lib, stdenv
, fetchFromGitHub
, aws-c-auth
, aws-c-cal
, aws-c-common
, aws-c-compression
, aws-c-event-stream
, aws-c-http
, aws-c-io
, aws-c-mqtt
, aws-c-s3
, aws-checksums
, cmake
, s2n-tls
}:

stdenv.mkDerivation rec {
  pname = "aws-crt-cpp";
  version = "0.17.8";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "aws-crt-cpp";
    rev = "v${version}";
    sha256 = "sha256-eHABIg3v5ycpQzacW/8C74PT6yDOXGmJqDa9P1hN7Mo=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace '-Werror' ""
  '';

  nativeBuildInputs = [
    cmake
  ];

  propagatedBuildInputs = [
    aws-c-auth
    aws-c-cal
    aws-c-common
    aws-c-compression
    aws-c-event-stream
    aws-c-http
    aws-c-io
    aws-c-mqtt
    aws-c-s3
    aws-checksums
    s2n-tls
  ];

  cmakeFlags = [
    "-DBUILD_DEPS=OFF"
    "-DCMAKE_SKIP_BUILD_RPATH=OFF"
    "-DBUILD_SHARED_LIBS=ON"
  ];

  meta = with lib; {
    description = "C++ wrapper around the aws-c-* libraries";
    homepage = "https://github.com/awslabs/aws-crt-cpp";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ r-burns ];
  };
}
