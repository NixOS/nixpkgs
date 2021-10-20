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
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "aws-crt-cpp";
    rev = "v${version}";
    sha256 = "0ijvyg3hrh1d0npca62syz8qy6nkqh90fq54cqyln0p333z16q52";
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
