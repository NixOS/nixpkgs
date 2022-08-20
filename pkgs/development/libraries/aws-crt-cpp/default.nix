{ lib, stdenv
, fetchFromGitHub
, fetchpatch
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
  version = "0.17.28";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "aws-crt-cpp";
    rev = "v${version}";
    sha256 = "sha256-4/BgwX8Pa5D2lEn0Dh3JlUiYUtA9u0rWpBixqmv1X/A=";
  };

  patches = [
    # Correct include path for split outputs.
    # https://github.com/awslabs/aws-crt-cpp/pull/325
    ./0001-build-Make-includedir-properly-overrideable.patch

    # Fix build with new input stream api
    # https://github.com/awslabs/aws-crt-cpp/pull/341
    # Remove with next release
    (fetchpatch {
      url = "https://github.com/awslabs/aws-crt-cpp/commit/8adb8490fd4f1d1fe65aad01b0a7dda0e52ac596.patch";
      excludes = [ "crt/*" ];
      sha256 = "190v8rlj6z0qllih6w3kqmdvqjifj66hc4bchsgr3gpfv18vpzid";
    })
  ];

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
    "-DBUILD_SHARED_LIBS=ON"
  ];

  postInstall = ''
    # Prevent dependency cycle.
    moveToOutput lib/aws-crt-cpp/cmake "$dev"
  '';

  meta = with lib; {
    description = "C++ wrapper around the aws-c-* libraries";
    homepage = "https://github.com/awslabs/aws-crt-cpp";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ r-burns ];
  };
}
