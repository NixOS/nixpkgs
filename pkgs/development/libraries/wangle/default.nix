{ stdenv
, lib
, fetchFromGitHub
, cmake
, boost
, libevent
, double-conversion
, glog
, fmt_8
, gflags
, openssl
, fizz
, folly
, gtest
, libsodium
, zlib
}:

stdenv.mkDerivation rec {
  pname = "wangle";
  version = "2023.04.03.00";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "wangle";
    rev = "v${version}";
    sha256 = "sha256-ISf/ezcJKCNv5UEGSf+OmHjV+QkanbTNoAm2ci1qy0o=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeDir = "../wangle";

  cmakeFlags = [
    "-Wno-dev"
  ] ++ lib.optionals stdenv.isDarwin [
    "-DBUILD_TESTS=off" # Tests fail on Darwin due to missing utimensat
    "-DCMAKE_OSX_DEPLOYMENT_TARGET=10.14" # For aligned allocation
  ];

  buildInputs = [
    fmt_8
    libsodium
    zlib
    boost
    double-conversion
    fizz
    folly
    gtest
    glog
    gflags
    libevent
    openssl
  ];

  meta = with lib; {
    description = "An open-source C++ networking library";
    longDescription = ''
      Wangle is a framework providing a set of common client/server
      abstractions for building services in a consistent, modular, and
      composable way.
    '';
    homepage = "https://github.com/facebook/wangle";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ pierreis kylesferrazza ];
  };
}
